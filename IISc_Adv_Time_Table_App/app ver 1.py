import streamlit as st
import matplotlib.pyplot as plt
import pandas as pd

from timetable_utils import (
    extract_table_excel, set_mandatory, set_selected, format_weekly_schedule,
    validate_against, plot_and_add_blocks_for_list, format_overlap, slot_to_str
)

#State Memory
# Initialize session state variables once
if "mandatory_courses" not in st.session_state:
    st.session_state["mandatory_courses"] = []
if "additional_courses" not in st.session_state:
    st.session_state["additional_courses"] = []
if "df" not in st.session_state:
    st.session_state["df"] = None



st.title("IISc M.Tech Course Timetable Planner")

uploaded_file = st.file_uploader("Upload your Excel file", type=["xlsx"])
default_file = "Aug 2025 term courses.xlsx"
use_default = st.button("Use Default File - "+ default_file )

if uploaded_file:
    df = extract_table_excel(uploaded_file)
elif use_default:
    df = extract_table_excel(default_file)  # place this file in your repo
else:
    df = None
    
if df is not None:

    st.subheader("All Courses")
    st.dataframe(df[["Course Code", "Course Name", "Approved Time Slot"]])

    # Define intended mandatory defaults
    intended_mandatory = [
        "ME 242 - Solid Mechanics",
        "ME 201 - Fluid Mechanics",
        "ME 261 - Engineering Mathematics"
    ]

    # Keep only those mandatory defaults that are actually in the dataframe
    available_mandatory = [c for c in intended_mandatory if c in df["Display Name"].tolist()]

    mandatory_courses = st.multiselect(
        "Select mandatory courses",
        options=df["Display Name"].tolist(),
        default=available_mandatory
    )


    df, valid = set_mandatory(df, mandatory_courses)
    st.subheader("Conflicts")

    conflicts_df = df.loc[df["Feasible"] == False, ["Course Code", "Weekly Schedule", "Overlap"]].copy()

    conflicts_df["Weekly Schedule"] = conflicts_df["Weekly Schedule"].apply(format_weekly_schedule)
    conflicts_df["Overlap"] = conflicts_df["Overlap"].apply(format_overlap)

    if not conflicts_df.empty:
        st.error("⚠️ Some courses have timetable clashes.")
        st.table(conflicts_df)
    else:
        st.success("✅ No timetable clashes detected.")


    st.subheader("Mandatory Timetable")
    fig, ax = plot_and_add_blocks_for_list(df[df["Selected"]])
    st.pyplot(fig)

    feasible_df = df[df["Feasible"] == True].copy()

    # Define intended defaults
    intended_defaults = [
        "MT 273 - Semiconductor Films: Deposition and Spectroscopic Characterization",
        "ME 246 - Introduction to Robotics",
        "ME 285 - Turbomachine Theory"
    ]

    # Keep only those defaults that are actually in the dataframe
    available_defaults = [c for c in intended_defaults if c in feasible_df["Display Name"].tolist()]

    additional_courses = st.multiselect(
        "Select additional courses",
        options=feasible_df["Display Name"].tolist(),
        default=available_defaults
    )



    df, valid = set_selected(df, additional_courses)
    df = validate_against(df, True)

    st.subheader("Final Timetable")
    fig2, ax2 = plot_and_add_blocks_for_list(df[df["Selected"]])
    st.pyplot(fig2)
    st.subheader("Conflicts")

        
    # --- Download timetable as image ---
    import io
    buf = io.BytesIO()
    fig2.savefig(buf, format="png")
    st.download_button(
        label="📥 Download Timetable as Image",
        data=buf.getvalue(),
        file_name="timetable.png",
        mime="image/png"
    )

    # --- Download timetable as Excel ---
    selected_df = df[df["Selected"]][["Course Code", "Course Name", "Approved Time Slot"]]
    excel_buf = io.BytesIO()
    with pd.ExcelWriter(excel_buf, engine="openpyxl") as writer:
        selected_df.to_excel(writer, index=False, sheet_name="Timetable")
    st.download_button(
        label="📥 Download Timetable as Excel",
        data=excel_buf.getvalue(),
        file_name="timetable.xlsx",
        mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    # --- Conflicts (only for selected courses) ---
    conflicts_df = df[(df["Selected"]) & (df["Feasible"] == False)].copy()

    if not conflicts_df.empty:
        # Format Weekly Schedule nicely
        conflicts_df["Weekly Schedule"] = conflicts_df["Weekly Schedule"].apply(format_weekly_schedule)

        # Format Overlap column into readable text
        conflicts_df["Overlap"] = conflicts_df["Overlap"].apply(format_overlap)

        st.error("⚠️ Some of your selected courses have timetable clashes.")
        st.dataframe(
            conflicts_df[["Course Code", "Weekly Schedule", "Overlap"]],
            use_container_width=True,
            column_config={
                "Course Code": st.column_config.TextColumn("Course Code", width="small"),
                "Weekly Schedule": st.column_config.TextColumn("Weekly Schedule", width="medium"),
                "Overlap": st.column_config.TextColumn("Overlap", width="large"),
            }
        )
    else:
        st.success("✅ No clashes among your selected courses.")
