// In-Ground Worm Bin - Inner Shell
// Parameters are imported from parameters.scad

include <../config/parameters.scad>;

// Create a single ridge
module ridge(height) {
    translate([inner_diameter/2, 0, height/2])
        cube([ridge_depth, ridge_width, height], center=true);
}

// Render the inner shell with ridges
module inner_shell() {
    union() {
        difference() {
            cylinder(h = inner_height, d = inner_diameter, center = false, $fn=100);
            translate([0, 0, outer_wall_thickness])  // Leave bottom wall thickness
                cylinder(h = inner_height, d = inner_diameter - 2 * outer_wall_thickness, center = false, $fn=100);
        }
        
        // Add ridges
        for (i = [0:ridge_count-1]) {
            angle = i * 360 / ridge_count;
            rotate([0, 0, angle])
                ridge(inner_height);
        }
    }
}

// Always render the inner shell when this file is processed directly
inner_shell(); 