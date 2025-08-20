import io
import hashlib
import json
import streamlit as st
import matplotlib.pyplot as plt
import pandas as pd

from timetable_utils import (
    extract_table_excel, set_mandatory, set_selected, format_weekly_schedule,
    validate_against, plot_and_add_blocks_for_list, format_overlap
)

# =========================
# Session State Init
# =========================
if "df" not in st.session_state:
    st.session_state.df = None
if "data_source" not in st.session_state:
    st.session_state.data_source = None           # "upload" | "default"
if "dataset_sig" not in st.session_state:
    st.session_state.dataset_sig = None           # signature to detect dataset change
if "mandatory_courses" not in st.session_state:
    st.session_state.mandatory_courses = []
if "additional_courses" not in st.session_state:
    st.session_state.additional_courses = []

st.title("IISc M.Tech Course Timetable Planner")

# =========================
# File Controls (Upload / Default)
# =========================
uploaded_file = st.file_uploader("📂 Upload your Excel file", type=["xlsx"])
default_file_folder = "IISc_Adv_Time_Table_App/"
default_file = "Aug 2025 term courses.xlsx"
use_default = st.button(f"Use Default File – {default_file}")

# Load or switch dataset into session_state
if uploaded_file is not None:
    st.session_state.df = extract_table_excel(uploaded_file)
    st.session_state.data_source = "upload"
elif use_default:
    st.session_state.df = extract_table_excel(default_file_folder+default_file)
    st.session_state.data_source = "default"

df = st.session_state.df

if df is None:
    st.info("Upload an Excel file or click **Use Default File** to get started.")
    st.stop()

# =========================
# Detect dataset change & initialize defaults once per dataset
# =========================
all_display_names = df.loc[df["Non_Duplicate"], "Display Name"].astype(str).tolist()
current_sig = hashlib.md5(json.dumps(sorted(all_display_names)).encode()).hexdigest()

# Intended defaults
INTENDED_MANDATORY = [
    "ME 242 - Solid Mechanics",
    "ME 201 - Fluid Mechanics",
    "ME 261 - Engineering Mathematics",
]
INTENDED_ADDITIONAL = [
    "MT 273 - Semiconductor Films: Deposition and Spectroscopic Characterization",
    "ME 246 - Introduction to Robotics",
    "ME 285 - Turbomachine Theory",
]
mand_defaults = [c for c in INTENDED_MANDATORY if c in all_display_names]
add_defaults = [c for c in INTENDED_ADDITIONAL if c in all_display_names and c not in mand_defaults]

def _apply_defaults():
    st.session_state.mandatory_courses = mand_defaults
    st.session_state.additional_courses = add_defaults

# Only apply defaults when dataset changes
if st.session_state.dataset_sig != current_sig:
    st.session_state.dataset_sig = current_sig
    _apply_defaults()

# Sanitize existing selections
st.session_state.mandatory_courses = [
    c for c in st.session_state.mandatory_courses if c in all_display_names
]
additional_options = [c for c in all_display_names if c not in st.session_state.mandatory_courses]
st.session_state.additional_courses = [
    c for c in st.session_state.additional_courses if c in additional_options
]

# =========================
# All Courses (basic table)
# =========================
st.subheader("All Courses")
st.dataframe(
    df[["Course Code", "Course Name", "Approved Time Slot"]],
    use_container_width=True,
    column_config={
        "Course Code": st.column_config.TextColumn("Course Code", width="small"),
        "Course Name": st.column_config.TextColumn("Course Name", width="medium"),
        "Approved Time Slot": st.column_config.TextColumn("Approved Time Slot", width="large"),
    },
)

# =========================
# Mandatory selection
# =========================
st.multiselect(
    "Select mandatory courses",
    options=all_display_names,
    key="mandatory_courses",
    default=st.session_state.mandatory_courses,
)

# Update additional options
additional_options = [c for c in all_display_names if c not in st.session_state.mandatory_courses]
st.session_state.additional_courses = [
    c for c in st.session_state.additional_courses if c in additional_options
]

df, _ = set_mandatory(df, st.session_state.mandatory_courses)

# =========================
# Mandatory Timetable
# =========================
st.subheader("Mandatory Timetable")
fig_mand, ax_mand = plot_and_add_blocks_for_list(df[(df["Selected"]) & (df["Mandatory"])])
st.pyplot(fig_mand)

# =========================
# Conflicts in Mandatory
# =========================
st.subheader("Conflicts within Mandatory Selection")
conflicts_mand_df = df[(df["Selected"]) & (df["Mandatory"]) & (df["Feasible"] == False)].copy()

if not conflicts_mand_df.empty:
    conflicts_mand_df["Weekly Schedule"] = conflicts_mand_df["Weekly Schedule"].apply(format_weekly_schedule)
    conflicts_mand_df["Overlap"] = conflicts_mand_df["Overlap"].apply(format_overlap)
    st.error("⚠️ Some mandatory selections clash:")
    st.dataframe(
        conflicts_mand_df[["Course Code", "Weekly Schedule", "Overlap"]],
        use_container_width=True,
        column_config={
            "Course Code": st.column_config.TextColumn("Course Code", width="small"),
            "Weekly Schedule": st.column_config.TextColumn("Weekly Schedule", width="medium"),
            "Overlap": st.column_config.TextColumn("Overlap", width="large"),
        },
    )
else:
    st.success("✅ No timetable clashes detected within the mandatory selection.")

# =========================
# Additional selection
# =========================
st.multiselect(
    "Select additional courses",
    options=additional_options,
    key="additional_courses",
    default=st.session_state.additional_courses,
)

# =========================
# Apply selections & validate
# =========================
df, _ = set_mandatory(df, st.session_state.mandatory_courses)
df, _ = set_selected(df, st.session_state.additional_courses)
df = validate_against(df, Only_Selected_Bool=True)
st.session_state.df = df

# =========================
# Final Timetable
# =========================
st.subheader("Final Timetable")
fig2, ax2 = plot_and_add_blocks_for_list(df[df["Selected"]])
st.pyplot(fig2)

# =========================
# Downloads
# =========================
png_buf = io.BytesIO()
fig2.savefig(png_buf, format="png")
st.download_button(
    label="📥 Download Timetable as Image",
    data=png_buf.getvalue(),
    file_name="timetable.png",
    mime="image/png",
)

selected_df = df[df["Selected"]][[
    "Sl No",
    "Course Code",
    "Course Name",
    "Credit",
    "Level",
    "Department",
    "Faculty",
    "Approved Time Slot",
    "Venue",
    "Division",
    "Academic Year",
    "Academic Session"
]]

excel_buf = io.BytesIO()
with pd.ExcelWriter(excel_buf, engine="openpyxl") as writer:
    selected_df.to_excel(writer, index=False, sheet_name="Timetable")
st.download_button(
    label="📥 Download Timetable as Excel",
    data=excel_buf.getvalue(),
    file_name="timetable.xlsx",
    mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
)

# =========================
# Conflicts (Selected)
# =========================
st.subheader("Conflicts (Selected Courses Only)")
conflicts_sel_df = df[(df["Selected"]) & (df["Feasible"] == False)].copy()

if not conflicts_sel_df.empty:
    conflicts_sel_df["Weekly Schedule"] = conflicts_sel_df["Weekly Schedule"].apply(format_weekly_schedule)
    conflicts_sel_df["Overlap"] = conflicts_sel_df["Overlap"].apply(format_overlap)

    st.error("⚠️ Some of your selected courses have timetable clashes.")
    st.dataframe(
        conflicts_sel_df[["Course Code", "Weekly Schedule", "Overlap"]],
        use_container_width=True,
        column_config={
            "Course Code": st.column_config.TextColumn("Course Code", width="small"),
            "Weekly Schedule": st.column_config.TextColumn("Weekly Schedule", width="medium"),
            "Overlap": st.column_config.TextColumn("Overlap", width="large"),
        },
    )
else:
    st.success("✅ No clashes among your selected courses.")
