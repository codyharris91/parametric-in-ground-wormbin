// In-Ground Worm Bin - Main Assembly
// Combines all components

/* [Bin Dimensions] */
// Diameter of the outer shell (mm)
outer_diameter = 300;
// Height of the outer shell (mm)
outer_height = 400;
// Wall thickness for both shells (mm)
outer_wall_thickness = 3;

/* [Tolerances] */
// Gap between inner and outer shells (mm)
tolerance = 0.2;
// Gap for top cap fit (mm)
cap_tolerance = 0.5;

/* [Alignment Features] */
// Width of ridge and channel (mm)
ridge_width = 5;
// Depth of ridge (fraction of wall thickness)
ridge_depth_factor = 0.5;
// Number of ridges around circumference
ridge_count = 4;

/* [Top Cap] */
// Height of the top cap (mm)
cap_height = 30;
// Thickness of the cap's top surface (mm)
cap_thickness = 5;
// Ratio of top platform diameter to outer diameter (0.5-1.0)
top_diameter_ratio = 0.9;
// Height of the elevated platform (mm)
platform_height = 25;
// Number of grip notches around the perimeter
grip_notches = 8;
// Height of the dome on top (mm)
dome_height = 25;
// Height of the handle ridge above the dome (mm)
handle_height = 15;
// Width/thickness of the handle ridge (mm)
handle_width = 30;

// Calculated parameters
ridge_depth = outer_wall_thickness * ridge_depth_factor;
inner_diameter = outer_diameter - 2 * (outer_wall_thickness + tolerance);
inner_height = outer_height - outer_wall_thickness;

// Import modules
use <components/outer-shell.scad>;
use <components/inner-shell.scad>;
use <components/top-cap.scad>;

/* [Display Options] */
// What to render
show_outer_shell = true;
show_inner_shell = true;
show_top_cap = true;
// Position of the cap (0 = removed, 1 = fully seated)
cap_position = 0;

// Render the components based on display options
if (show_outer_shell) {
    outer_shell(
        outer_diameter = outer_diameter,
        outer_height = outer_height,
        outer_wall_thickness = outer_wall_thickness,
        ridge_width = ridge_width,
        ridge_depth = ridge_depth,
        ridge_count = ridge_count,
        tolerance = tolerance
    );
}

if (show_inner_shell) {
    translate([0, 0, outer_wall_thickness]) // Position inner shell on the bottom of outer shell
        color("LightGreen") inner_shell(
            inner_diameter = inner_diameter,
            inner_height = inner_height,
            outer_wall_thickness = outer_wall_thickness,
            ridge_width = ridge_width,
            ridge_depth = ridge_depth,
            ridge_count = ridge_count
        );
}

if (show_top_cap) {
    // Position the cap based on cap_position (0 = removed, 1 = fully seated)
    cap_offset = cap_position * cap_height;
    translate([0, 0, outer_height - cap_offset])
        color("SteelBlue") top_cap(
            outer_diameter = outer_diameter,
            outer_wall_thickness = outer_wall_thickness,
            cap_height = cap_height,
            cap_thickness = cap_thickness,
            cap_tolerance = cap_tolerance,
            top_diameter_ratio = top_diameter_ratio,
            platform_height = platform_height,
            grip_notches = grip_notches
        );
}

// Add some basic information
echo("Outer shell diameter: ", outer_diameter, "mm");
echo("Inner shell diameter: ", inner_diameter, "mm");
echo("Gap between shells: ", tolerance, "mm"); 