// Circular Worm Bin - Nested Cylindrical Design
// Parameters for customization

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

// Create a single ridge
module ridge(height) {
    translate([inner_diameter/2, 0, height/2])
        cube([ridge_depth, ridge_width, height], center=true);
}

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
        
        // Add channels - make them deeper for visibility
        for (i = [0:ridge_count-1]) {
            angle = i * 360 / ridge_count;
            rotate([0, 0, angle])
                channel(outer_height);
        }
    }
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

// Render both shells
outer_shell();
translate([0, 0, outer_wall_thickness]) // Position inner shell on the bottom of outer shell
    color("LightGreen") inner_shell();

// Add some basic information
echo("Outer shell diameter: ", outer_diameter, "mm");
echo("Inner shell diameter: ", inner_diameter, "mm");
echo("Gap between shells: ", tolerance, "mm");
