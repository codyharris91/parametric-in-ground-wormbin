// In-Ground Worm Bin - Outer Shell
// Parameters are imported from parameters.scad

include <../config/parameters.scad>;

// Create a single channel
module channel(height) {
    // Position the channel on the inside wall of the outer shell
    translate([outer_diameter/2 - outer_wall_thickness, 0, (outer_height + outer_wall_thickness)/2])
        cube([ridge_depth + tolerance, ridge_width + tolerance*2, outer_height - outer_wall_thickness], center=true);
}

// Render the outer shell with channels
module outer_shell() {
    difference() {
        cylinder(h = outer_height, d = outer_diameter, center = false, $fn=100);
        
        // Hollow out the inside
        translate([0, 0, outer_wall_thickness])  // Leave bottom wall thickness
            cylinder(h = outer_height, d = outer_diameter - 2 * outer_wall_thickness, center = false, $fn=100);
        
        // Add channels
        for (i = [0:ridge_count-1]) {
            angle = i * 360 / ridge_count;
            rotate([0, 0, angle])
                channel(outer_height);
        }
    }
}

// Always render the outer shell when this file is processed directly
outer_shell(); 