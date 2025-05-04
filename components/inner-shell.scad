// In-Ground Worm Bin - Inner Shell
// Parameters are passed from main.scad

// Render the inner shell with ridges fused in
module inner_shell(
    inner_diameter = 300,
    inner_height = 400,
    outer_wall_thickness = 3,
    ridge_width = 5,
    ridge_depth = 1.5,
    ridge_count = 4
) {
    union() {
        // Main shell body
        difference() {
            cylinder(h = inner_height, d = inner_diameter, center = false, $fn=100);
            translate([0, 0, outer_wall_thickness])  // Leave bottom wall thickness
                cylinder(h = inner_height, d = inner_diameter - 2 * outer_wall_thickness, center = false, $fn=100);
        }
        // Fused ridges
        for (i = [0:ridge_count-1]) {
            angle = i * 360 / ridge_count;
            rotate([0, 0, angle])
                translate([inner_diameter/2, 0, inner_height/2])
                    cube([ridge_depth, ridge_width, inner_height], center=true);
        }
    }
}

// When this file is opened directly, use default parameters
if ($filename == "inner-shell.scad") {
    inner_shell();
} 