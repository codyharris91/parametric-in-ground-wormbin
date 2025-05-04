// In-Ground Worm Bin - Top Cap
// Parameters are passed from main.scad

// Render a top cap with a taller sloped section and grip handles
module top_cap(
    outer_diameter = 300,
    outer_wall_thickness = 3,
    cap_height = 30,       // Height of the cap base
    cap_tolerance = 0.5,   // Tolerance for easy sliding over the outer shell
    top_protrusion_height = 50, // Height of the sloped section
    top_diameter_ratio = 0.9, // Ratio of top diameter to bottom diameter (90%)
    
    // Handle parameters
    handle_width = 60,     // Width of the handle cutout
    handle_length = 25,    // Length of the handle cutout
    handle_height = 15,    // Height/depth of the handle cutout
    handle_radius = 10     // Radius for the rounded corners
) {
    // Calculate diameters
    cap_inner_diameter = outer_diameter + cap_tolerance * 2;
    cap_outer_diameter = cap_inner_diameter + 2 * outer_wall_thickness;
    top_protrusion_diameter = cap_outer_diameter * top_diameter_ratio; // 90% of the bottom diameter
    
    // Handle dimensions
    handle_width = top_protrusion_diameter * 0.4;  // 40% of the top diameter
    handle_length = 30; 
    handle_height = 20;
    handle_radius = 10;
    
    difference() {
        // Create the entire outer shape in one piece
        union() {
            // Main cylindrical portion
            cylinder(h = cap_height, d = cap_outer_diameter, center = false, $fn=100);
            
            // Sloped portion
            translate([0, 0, cap_height])
                cylinder(h = top_protrusion_height, 
                        d1 = cap_outer_diameter, 
                        d2 = top_protrusion_diameter, 
                        center = false, $fn=100);
                        
            // Flat top
            translate([0, 0, cap_height + top_protrusion_height - outer_wall_thickness])
                cylinder(h = outer_wall_thickness, 
                        d = top_protrusion_diameter, 
                        center = false, $fn=100);
        }
        
        // Use a single complex shape for hollowing to ensure perfect transition
        hull() {
            // Bottom cylinder
            translate([0, 0, -1])
                cylinder(h = 1, d = cap_inner_diameter, center = false, $fn=100);
            
            // Junction cylinder (positioned exactly at the transition point)
            translate([0, 0, cap_height])
                cylinder(h = 0.01, d = cap_inner_diameter, center = false, $fn=100);
            
            // Top cylinder (just below the flat top)
            translate([0, 0, cap_height + top_protrusion_height - outer_wall_thickness - 0.01])
                cylinder(h = 0.01, 
                        d = top_protrusion_diameter - 2 * outer_wall_thickness, 
                        center = false, $fn=100);
        }
        
        // Add two clear handle cutouts - simplified approach
        // First handle
        translate([-handle_width/2, -top_protrusion_diameter/4, cap_height + top_protrusion_height - handle_height])
            hull() {
                translate([handle_radius, handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_width - handle_radius, handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_radius, handle_length - handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_width - handle_radius, handle_length - handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
            }
            
        // Second handle - opposite side
        translate([-handle_width/2, top_protrusion_diameter/4 - handle_length, cap_height + top_protrusion_height - handle_height])
            hull() {
                translate([handle_radius, handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_width - handle_radius, handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_radius, handle_length - handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
                translate([handle_width - handle_radius, handle_length - handle_radius, 0])
                    cylinder(r = handle_radius, h = handle_height + 1, $fn = 32);
            }
    }
}

// When this file is opened directly, use default parameters
if ($filename == "top-cap.scad") {
    top_cap();
} 