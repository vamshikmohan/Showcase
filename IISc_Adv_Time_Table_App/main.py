import pandas as pd
import re
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import hashlib

## Weekly Schedule Extractor by string
def blocks(inp):
    raw = inp.strip().upper()
    blocks = []
    current = ''

    def looks_like_time_end(text):
        # Matches: 9, 9:00, 10-11, 10:30 AM, 5 PM, etc.
        return bool(re.search(r'(\d+(:\d{1,2})?(\s*(AM|PM))?)\s*$', text))

    i = 0
    while i < len(raw):
        char = raw[i]
        if char not in [',', ';', '&']:
            current += char
            i += 1
            continue

        lookback = current.strip()
        if looks_like_time_end(lookback):
            # Possible new block after this separator
            j = i + 1
            while j < len(raw) and raw[j] in [' ', '\t']:
                j += 1
            if j < len(raw) and raw[j] in ['M', 'T', 'W', 'F', 'S']:
                blocks.append(current.strip())
                current = ''
        else:
            # Comma is inside time range or text — keep it
            current += char

        i += 1

    if current.strip():
        blocks.append(current.strip())

    return blocks
def days(inp):
    inp = inp.replace("AM","")
    inp = inp.replace("PM","")
    i=0

    days = []

    if 'TH' in inp:
        days.append('Thursday')

    daymap = {'M':'Monday','T':'Tuesday','W':'Wednesday','F':'Friday','S':'Saturday'}

    for d in ['M','T','W','F','s']:
        if d in inp.replace('TH',''):
            days.append(daymap[d])

    return days
def to_24hr(time_str, ampm=None):
    parts = time_str.split(":")
    hour = int(parts[0])
    minute = int(parts[1]) if len(parts) > 1 else 0

    if ampm:  # Explicit AM/PM
        ampm = ampm.upper()
        if ampm == "PM" and hour != 12:
            hour += 12
        elif ampm == "AM" and hour == 12:
            hour = 0
    else:
        # No AM/PM → apply the "12–7 rule"
        if 12 <= hour <= 19 or (1 <= hour <= 7):
            if hour != 12:  # convert to PM unless already 12
                hour += 12

    return f"{hour:02d}:{minute:02d}"
def extract_time_pairs(text):
    # Split on & or commas into separate ranges
    text = text.replace('.',':')
    ranges = re.split(r'[&,\n]', text)

    time_pattern = r'(\d{1,2}(:\d{1,2})?)\s*(AM|PM)?'
    pairs = []

    for rng in ranges:
        matches = re.findall(time_pattern, rng, re.IGNORECASE)
        ampm_info = [m[2].upper() if m[2] else None for m in matches]

        # Pair-level AM/PM inference
        for i in range(0, len(matches), 2):
            if i + 1 >= len(matches):
                break

            am1, am2 = ampm_info[i], ampm_info[i+1]

            # If neither time has AM/PM and both missing → leave None
            # If exactly one has AM/PM → copy to other
            if (am1 is None and am2 is not None) or (am1 is not None and am2 is None):
                # Copy only if one is None and the other is not
                if am1 is None:
                    ampm_info[i] = am2
                else:
                    ampm_info[i+1] = am1
            # If both have AM/PM → keep as-is

        # Convert to 24-hour format
        times_24 = []
        for i, m in enumerate(matches):
            t = m[0]  # '11:00' or '2'
            ampm = ampm_info[i]

            if ':' in t:
                h, mi = t.split(':')
            else:
                h, mi = t, '00'
            h, mi = int(h), int(mi)

            if ampm == "PM" and h != 12:
                h += 12
            elif ampm == "AM" and h == 12:
                h = 0

            times_24.append(f"{h:02d}:{mi:02d}")

        # Store as pairs
        for i in range(0, len(times_24), 2):
            if i + 1 < len(times_24):
                pairs.append((times_24[i], times_24[i+1]))

    return pairs
def weekly_schedule(text):
    day_order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    day_map = {d: i for i, d in enumerate(day_order)}

    result = [[("na", "na")] for _ in day_order]

    def time_to_decimal(t):
        if t == "na":
            return -1
        h, m = map(int, t.split(":"))
        return h + m / 60

    for block in blocks(text):
        d_list = days(block)  # returns list of full day names
        time_pairs = extract_time_pairs(block)  # returns list of (start,end)

        for d in d_list:
            idx = day_map[d]
            if result[idx] == [("na", "na")]:
                result[idx] = []

            for tp in time_pairs:
                if tp not in result[idx]:
                    result[idx].append(tp)

    # Postprocess: convert all to decimal hours
    processed_result = []
    for day_times in result:
        processed_day = []
        for start, end in day_times:
            processed_day.append((time_to_decimal(start), time_to_decimal(end)))
        processed_result.append(processed_day)

    return processed_result

## Graphics
def draw_timetable_with_title(roundness=0.1):
    fig, ax = plt.subplots(figsize=(10, 6))

    # Grid position
    grid_x0, grid_y0 = 1, 1
    grid_x1, grid_y1 = 13, 7  # 12 hours, 6 days
    cell_height = (grid_y1 - grid_y0) / 6
    cell_width = (grid_x1 - grid_x0) / 11

    # Draw grid for timetable
    for i in range(7):  # horizontal lines
        ax.plot([grid_x0, grid_x1], [grid_y0 + i * cell_height, grid_y0 + i * cell_height], color="#2B3236D5")

    for j in range(12):  # vertical hour lines
        ax.plot([grid_x0 + j * cell_width, grid_x0 + j * cell_width], [grid_y0 - 0.1, grid_y1], color= "#2B323689")

    # Extra vertical dashed lines for half-hours
    for j in range(11):  # between each hour
        half_x = grid_x0 + j * cell_width + cell_width / 2
        ax.plot([half_x, half_x], [grid_y0, grid_y1], color="#667E8274", linestyle="dashed", linewidth=0.8)

    # Day labels
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    days.reverse()
    for i, day in enumerate(days):
        ax.text(grid_x0 - 0.2, grid_y0 + (i + 0.5) * cell_height, day,
                va="center", ha="right", fontsize=10, fontweight="bold", color = "#3A3A49")

    # Time labels
    times = [f"{7 + h:02d}:00" for h in range(12)]
    for j, time in enumerate(times):
        ax.text(grid_x0 + (j) * cell_width, grid_y0 - 0.3, time,
                va="top", ha="center", fontsize=8, color = "#6F6F8A")

    # Title box coordinates
    title_x0, title_y0 = grid_x0 + 0.25, grid_y1 + 0.8
    title_x1, title_y1 = grid_x1 - 0.25, grid_y1 + 1.1

    # Rounded rectangle for title
    title_box = patches.FancyBboxPatch(
        (title_x0, title_y0),
        title_x1 - title_x0,
        title_y1 - title_y0,
        boxstyle=patches.BoxStyle("Round", rounding_size=roundness),
        linewidth=4,
        edgecolor="#6AAEDF2F",
        facecolor="none",
        linestyle="solid"
    )
    ax.add_patch(title_box)

    # Style
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 9)
    ax.text(
        (title_x0 + title_x1) / 2,  # center x
        (title_y0 + title_y1) / 2,  # center y
        "Time Schedule",             # title text
        va="center",
        ha="center",
        fontsize=12,
        fontweight="bold",
        color = "#1F4762FF"
    )
    ax.axis("off")

    ax.text(
        (title_x0 + title_x1) / 2,  # center x
        (grid_y0 - 1.2),  # center y
        "Time (Hrs) - 24 hour format",             # title text
        va="center",
        ha="center",
        fontsize=10,
        fontstyle = "italic",
        fontweight = "bold",
        color = "#70709B"
    )
    # Coordinates dictionary with cell dimensions
    coords = {
        "grid": {
            "x0": grid_x0 + 0.25, "y0": grid_y0 + 0.25, "x1": grid_x1 - 0.25, "y1": grid_y1 - 0.25,
            "cell_height": cell_height,
            "cell_width": cell_width
        },
        "title_box": {
            "x0": title_x0, "y0": title_y0, "x1": title_x1, "y1": title_y1
        }
    }

    return fig, ax, coords
def add_rounded_box(ax, x0, y0, x1, y1, roundness=0.2, edgecolor="#56676A2A", facecolor="#53D37C74", linewidth=2, linestyle="solid"):
    """
    Draws a rounded rectangle from point (x0, y0) to (x1, y1) 
    and adds it to the given matplotlib Axes.
    
    Parameters:
        ax (matplotlib.axes.Axes): The Axes to draw the box on.
        x0, y0 (float): Bottom-left corner coordinates.
        x1, y1 (float): Top-right corner coordinates.
        roundness (float): Corner roundness radius.
        edgecolor (str): Color of the box border.
        facecolor (str): Fill color.
        linewidth (float): Border line width.
        linestyle (str): Border style ("solid", "dashed", etc.).
        
    Returns:
        ax (matplotlib.axes.Axes): The Axes with the box added.
    """
    width = x1 - x0 - 0.5
    height = y1 - y0 - 0.5
    
    box = patches.FancyBboxPatch(
        (x0, y0), width, height,
        boxstyle=patches.BoxStyle("Round", rounding_size=roundness*min(width, height)),
        linewidth=linewidth,
        edgecolor=edgecolor,
        facecolor=facecolor,
        linestyle=linestyle
    )
    
    ax.add_patch(box)
    return ax
def darken_hex_color(hex_color, factor=0.8):
    # Remove "#" and parse
    hex_color = hex_color.lstrip("#")
    if len(hex_color) == 8:
        r, g, b, a = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4, 6))
    elif len(hex_color) == 6:
        r, g, b = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
        a = None
    else:
        raise ValueError("Hex color must be in RRGGBB or RRGGBBAA format")

    # Apply darkening factor
    r = max(0, min(255, int(r * factor)))
    g = max(0, min(255, int(g * factor)))
    b = max(0, min(255, int(b * factor)))

    # Return with alpha preserved if it was present
    if a is not None:
        return "#{:02X}{:02X}{:02X}{:02X}".format(r, g, b, a)
    else:
        return "#{:02X}{:02X}{:02X}".format(r, g, b)    
def add_block_for_time_slot(name, inp, ax, coords, roundness = 0.2, facecolor = "#56676A66", lineweight = 2):

    week = weekly_schedule(inp)
    x0 = coords['grid']['x0']
    y0 = coords['grid']['y0']
    w = coords['grid']['cell_width']
    h = coords['grid']['cell_height']

    d = 0
    for j in week:
        for i in j:
            if i[0] != -1 and (max(i))<=18 and (min(i))>=7:
                add_rounded_box(ax, x0 + w*(i[1]-7), y0 + h*(6 - d), x0 + w*(i[0]-7), y0 + h*(5 - d), roundness, facecolor=facecolor, linewidth=lineweight)
                ax.text((x0 + w*(i[1]-7) + x0 + w*(i[0]-7) - 0.5) / 2, (y0 + h*(6 - d) + y0 + h*(5 - d) - 0.5) / 2, name, ha="center", va="center", fontsize=6, fontweight="bold", color = darken_hex_color(facecolor, factor=0.4))
        d = d+1
    
    return ax
def string_to_hex_color(s):
    # Create a hash from the string
    alpha=0.4
    h = hashlib.md5(s.encode()).hexdigest()
    # First 6 characters for RGB
    r = int(h[0:2], 16)
    g = int(h[2:4], 16)
    b = int(h[4:6], 16)
    # Alpha channel
    a = int(alpha * 255)
    return f"#{r:02X}{g:02X}{b:02X}{a:02X}"
def plot_and_add_blocks_for_list(df):
    import matplotlib.pyplot as plt

    # Close any previously open plots
    plt.close('all')

    fig, ax, coords = draw_timetable_with_title(roundness=0.1)

    # Plot timetable blocks
    for _, row in df[df['Non_Duplicate'] == True].iterrows():
        add_block_for_time_slot(
            row['Course Code'], 
            row['Approved Time Slot'], 
            ax, coords, 
            roundness=0.1, 
            facecolor=row['Colour']
        )
        

    for _, row in df[(df['Mandatory'] == True) & (df['Non_Duplicate'] == True)].iterrows():
        add_block_for_time_slot(
            row['Course Code'], 
            row['Approved Time Slot'], 
            ax, coords, 
            roundness=0.1, 
            facecolor=row['Colour'], 
            lineweight=6
        )

    # === Selected courses box ===
    selected_df = df[(df['Selected'] == True) & (df['Non_Duplicate'] == True)][['Course Code', 'Course Name', 'Credit']]
    
    if selected_df.empty:
        return fig, ax

    # Format text content
    lines = ["**Selected Courses**\n"]  # heading
    for _, row in selected_df.iterrows():
        lines.append(f"{row['Course Code']} – {row['Course Name']} ({row['Credit']} cr)")
    text_content = "\n".join(lines)

    tolerance = 1  # gap below table in data units
    ymin, ymax = ax.get_ylim()
    table_bottom = ymin

    # Temporary text to measure size
    temp_text = ax.text(
        (coords["title_box"]['x0'] - 0.25), 
        table_bottom - tolerance,
        text_content,
        fontsize=8.5,
        fontweight='normal',
        ha='left', va='top',
        linespacing=1.4,
        bbox=dict(
            boxstyle="round,pad=0.5",
            facecolor="white",
            edgecolor="#1F5B7D",
            linewidth=1.2
        )
    )
    fig.canvas.draw()

    bbox = temp_text.get_window_extent(renderer=fig.canvas.get_renderer())
    inv = ax.transData.inverted()
    bbox_data = inv.transform([[0, bbox.y0], [0, bbox.y1]])
    box_height_data = abs(bbox_data[1][1] - bbox_data[0][1])

    temp_text.remove()

    # Final text with heading bold
    final_lines = ["\n  Selected Courses:                                                         \n"]  # heading separate for bold
    for _, row in selected_df.iterrows():
        final_lines.append(f"   \u2022 {row['Course Code']} – {row['Course Name']} ({row['Credit']})  ")
    final_content = "\n".join(final_lines)

    ax.text(
        (coords["title_box"]['x0'] - 0.25), 
        table_bottom - tolerance,
        final_content + "\n",
        fontsize=8.5,
        ha='left', va='top',
        linespacing=1.5,
        bbox=dict(
            boxstyle="round,pad=0.5",
            facecolor="#B4F1FF0A",
            linewidth=4,
            edgecolor="#6AAEDF2F"
        ),
    )

    # Extend limits
    new_ymin = table_bottom - tolerance - box_height_data
    ax.set_ylim(new_ymin, ymax - 0.6)

    return fig, ax

## Logic Check
def extract_table_excel(path):
    df = pd.read_excel(path, engine='openpyxl')
    df["Weekly Schedule"] = df["Approved Time Slot"].apply(weekly_schedule)
    df["Colour"] = df["Course Code"].apply(string_to_hex_color)
    df['Display Name'] = df['Course Code'].astype(str) + " - " + df['Course Name'].astype(str)
    df['Mandatory'] = False
    df['Feasible'] = True
    df['Selected'] = False
    df['Overlap'] = None

    # Mark only first occurrence as True, rest as False
    df['Non_Duplicate'] = ~df.duplicated(subset=["Course Code", "Approved Time Slot"], keep='first')

    return df
def set_mandatory(df, mandate_list):
    # Create a boolean mask: match against any of the three columns
    mask = (
        df['Display Name'].isin(mandate_list) |
        df['Course Code'].isin(mandate_list) |
        df['Course Name'].isin(mandate_list)
    )

    # Set Mandatory and Selected where mask is True
    df.loc[mask, 'Mandatory'] = True
    df.loc[mask, 'Selected'] = True

    df = validate_against(df, True)
    valid_mandatory_selection = df["Feasible"].all()

    return df, valid_mandatory_selection
def set_selected(df, selected_list):
    # Create a boolean mask: match against any of the three columns
    mask = (
        df['Display Name'].isin(selected_list) |
        df['Course Code'].isin(selected_list) |
        df['Course Name'].isin(selected_list)
    )

    # Set Mandatory and Selected where mask is True
    df.loc[mask, 'Selected'] = True
    df = validate_against(df, True)
    valid_selection = df["Feasible"].all()

    return df, valid_selection
def check_weekly_overlap(schedule1, schedule2):
    """
    schedule1, schedule2: list of lists of tuples [(start, end), ...] per day.
    Example: [[(10.0, 11.0)], [(-1, -1)], [(10.0, 11.0)], ...]
    Returns: (has_overlap, overlap_details)
    overlap_details = [(day_index, slot1, slot2), ...]
    """
    overlap_details = []

    for day_idx, (day_slots1, day_slots2) in enumerate(zip(schedule1, schedule2)):
        # Ignore days with no slots
        if all(s == (-1, -1) for s in day_slots1) and all(s == (-1, -1) for s in day_slots2):
            continue

        for slot1 in day_slots1:
            for slot2 in day_slots2:
                if slot1 == (-1, -1) or slot2 == (-1, -1):
                    continue
                start1, end1 = slot1
                start2, end2 = slot2

                # Overlap condition (partial or complete containment)
                if start1 < end2 and start2 < end1:
                    overlap_details.append((day_idx, slot1, slot2))

    has_overlap = len(overlap_details) > 0
    return has_overlap, overlap_details
def validate_against(df, Only_Selected_Bool=False):
    # Choose rows to check
    if Only_Selected_Bool:
        rows_to_check = df[(df["Selected"]) & (df["Non_Duplicate"])]
    else:
        rows_to_check = df[df["Non_Duplicate"]]

    indices = list(rows_to_check.index)

    # Initialize only for rows being checked
    df.loc[indices, "Feasible"] = True
    df.loc[indices, "Overlap"] = None

    # Compare only unique pairs (i < j)
    for i in range(len(indices)):
        idx_i = indices[i]
        sched_i = df.at[idx_i, "Weekly Schedule"]

        for j in range(i + 1, len(indices)):
            idx_j = indices[j]

            # Only compare if at least one is "Selected"
            if not (df.at[idx_i, "Selected"] or df.at[idx_j, "Selected"]):
                continue

            sched_j = df.at[idx_j, "Weekly Schedule"]

            has_overlap, overlap_list = check_weekly_overlap(sched_i, sched_j)
            if has_overlap:
                # Mark both as infeasible
                df.at[idx_i, "Feasible"] = False
                df.at[idx_j, "Feasible"] = False

                # Append overlaps to both
                df.at[idx_i, "Overlap"] = (df.at[idx_i, "Overlap"] or []) + overlap_list
                df.at[idx_j, "Overlap"] = (df.at[idx_j, "Overlap"] or []) + overlap_list

    return df

## MAIN
df = extract_table_excel("Aug 2025 term courses.xlsx")
mandatory = ['ME 242', 'ME 201', 'ME 261']

#Setting Mandatory Courses
df, valid = set_mandatory(df, mandatory)

if not valid:
    print("Note: Mandatory Selection is not Valid")
    print(df.loc[df["Feasible"] == False, ["Course Code", "Weekly Schedule", "Overlap"]])

plot_and_add_blocks_for_list(df[df["Selected"]])
plt.show()

#Check for all feasible Courses and store it in Column "Feasible"
df = validate_against(df)
print(str(len(df.loc[df['Feasible'] == False])) + " Courses that clash with your Mandatory Courses:\n")
print(df.loc[df['Feasible'] == False, ["Course Code", "Approved Time Slot", "Overlap"]])

additional_selection = ['MT 273', 'ME 246', 'ME 285', 'ME 278', 'AE 211']
df, valid = set_selected(df, additional_selection)

plot_and_add_blocks_for_list(df[df["Selected"]])
plt.show()