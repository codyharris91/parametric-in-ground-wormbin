// In-Ground Worm Bin - Parameters
// Shared parameters for all components

// Outer shell dimensions
outer_diameter = 300; // mm
outer_height = 400;   // mm
outer_wall_thickness = 3; // mm

// Tolerance between shells
tolerance = 0.2; // mm - adjust based on your printer's accuracy

// Ridge and channel dimensions
ridge_width = 5; // mm
ridge_depth = outer_wall_thickness / 2; // Half the depth of outer shell wall
ridge_count = 4; // Number of ridges/channels around the circumference

// Inner shell dimensions (calculated from outer dimensions and tolerance)
inner_diameter = outer_diameter - 2 * (outer_wall_thickness + tolerance);
inner_height = outer_height - outer_wall_thickness; // Remove tolerance to make tops flush 