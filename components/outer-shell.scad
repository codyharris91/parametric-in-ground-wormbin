// In-Ground Worm Bin - Outer Shell
// Parameters are passed from main.scad

// Render the outer shell with channels fused in
module outer_shell(
    outer_diameter = 300,
    outer_height = 400,
    outer_wall_thickness = 3,
    ridge_width = 5,
    ridge_depth = 1.5,
    ridge_count = 4,
    tolerance = 0.2
) {
    difference() {
        // Main shell body
        cylinder(h = outer_height, d = outer_diameter, center = false, $fn=100);

        // Hollow out the inside
        translate([0, 0, outer_wall_thickness])  // Leave bottom wall thickness
            cylinder(h = outer_height, d = outer_diameter - 2 * outer_wall_thickness, center = false, $fn=100);

        // Fused channels
        for (i = [0:ridge_count-1]) {
            angle = i * 360 / ridge_count;
            rotate([0, 0, angle])
                translate([outer_diameter/2 - outer_wall_thickness, 0, (outer_height + outer_wall_thickness)/2])
                    cube([ridge_depth + tolerance, ridge_width + tolerance*2, outer_height - outer_wall_thickness], center=true);
        }
    }
}

// When this file is opened directly, use default parameters
if ($filename == "outer-shell.scad") {
    outer_shell();
} 