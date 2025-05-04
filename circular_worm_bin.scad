/*
 * Circular Worm Bin for In-Ground Use
 * 
 * This OpenSCAD model creates:
 * - An outer sheath that stays in the ground
 * - A removable inner bin that fits precisely inside
 * - Both with customizable holes for drainage and aeration
 * - Alignment tabs for proper positioning
 */

/* [Main Dimensions] */
// Diameter of the outer bin (mm)
bin_diameter = 100;
// Height of the outer bin (mm)
bin_height = 200;
// Thickness of the walls (mm)
wall_thickness = 3;

/* [Inner Bin] */
// Create inner bin?
create_inner_bin = true;
// Gap between outer and inner bin (mm)
inner_bin_tolerance = 0.5;
// Height reduction of inner bin (mm)
inner_bin_height_reduction = 10;

/* [Alignment System] */
// Number of alignment tabs
alignment_count = 4;
// Width of alignment tabs (mm)
alignment_width = 8;
// Height of alignment tabs (mm)
alignment_height = 5;
// Depth of alignment tabs (mm)
alignment_depth = 2;
// Tolerance for alignment tabs (mm)
alignment_tolerance = 0.3;

/* [Rendering Quality] */
// Resolution for circular objects (higher = smoother but slower)
$fn = 32;

/* [Hole Sizes] */
// Diameter of side holes (mm)
side_hole_diameter = 10;
// Diameter of bottom holes (mm)
bottom_hole_diameter = 10;

/* [Side Hole Pattern] */
// Number of horizontal rows of holes
hole_rows = 8;
// Approximate number of holes per row
holes_per_row = 16;
// Offset every other row (0-1 range)
hole_offset = 0.5;
// Margin from top and bottom edges (mm)
side_hole_edge_margin = 15;

/* [Bottom Hole Pattern] */
// Number of rings of holes in the bottom
bottom_holes_rings = 3;
// Holes in the innermost ring (increases outward)
bottom_holes_per_ring = 6;
// Margin from edge (mm)
bottom_hole_edge_margin = 5;

// Calculate inner bin dimensions to fit precisely inside outer bin
inner_bin_outer_diameter = bin_diameter - 2*wall_thickness - 2*inner_bin_tolerance;
inner_bin_inner_diameter = inner_bin_outer_diameter - 2*wall_thickness;
inner_bin_height = bin_height - inner_bin_height_reduction;

// Create the main (outer) bin
module outer_bin() {
    difference() {
        // Outer cylinder
        cylinder(h=bin_height, d=bin_diameter);
        
        // Inner cylinder (hollow out the bin)
        translate([0, 0, wall_thickness])
            cylinder(h=bin_height, d=bin_diameter-2*wall_thickness);
        
        // Add subtle alignment notches at the top inner edge
        if (create_inner_bin) {
            for (i = [0:alignment_count-1]) {
                angle = i * 360 / alignment_count;
                rotate([0, 0, angle])
                translate([bin_diameter/2 - wall_thickness, 0, bin_height - alignment_height/2])
                cube([alignment_depth + alignment_tolerance, 
                      alignment_width + alignment_tolerance, 
                      alignment_height + alignment_tolerance], center=true);
            }
        }
        
        // Add side aeration/drainage holes with offset pattern
        for(row = [0:hole_rows-1]) {
            // Distribute holes with margin from top and bottom
            usable_height = bin_height - 2*side_hole_edge_margin;
            row_z = side_hole_edge_margin + (usable_height * (row + 0.5) / hole_rows);
            
            row_offset = (row % 2) * hole_offset; // Offset every other row
            
            for(i = [0:holes_per_row-1]) {
                angle = (i * 360 / holes_per_row) + (row_offset * (360 / holes_per_row));
                translate([
                    (bin_diameter/2) * cos(angle),
                    (bin_diameter/2) * sin(angle),
                    row_z
                ])
                rotate([0, 90, angle])
                    cylinder(h=wall_thickness*2, d=side_hole_diameter, center=true);
            }
        }
        
        // Add bottom drainage holes in concentric rings
        max_radius = (bin_diameter/2 - wall_thickness - bottom_hole_edge_margin);
        for(ring = [0:bottom_holes_rings-1]) {
            // Distribute rings from center to near edge
            ring_radius = max_radius * (ring + 1) / (bottom_holes_rings + 1);
            current_holes = bottom_holes_per_ring * (ring + 1);
            
            for(i = [0:current_holes-1]) {
                angle = i * 360 / current_holes;
                translate([
                    ring_radius * cos(angle),
                    ring_radius * sin(angle),
                    0
                ])
                cylinder(h=wall_thickness*2, d=bottom_hole_diameter, center=true);
            }
        }
    }
}

// Create the inner bin
module inner_bin() {
    difference() {
        union() {
            // Main cylinder - sized to fit inside the outer bin with tolerance
            cylinder(h=inner_bin_height, d=inner_bin_outer_diameter);
            
            // Add subtle alignment tabs at the top
            for (i = [0:alignment_count-1]) {
                angle = i * 360 / alignment_count;
                rotate([0, 0, angle])
                translate([inner_bin_outer_diameter/2, 0, inner_bin_height - alignment_height/2])
                cube([alignment_depth, alignment_width, alignment_height], center=true);
            }
        }
        
        // Hollow out the inner bin
        translate([0, 0, wall_thickness])
            cylinder(h=inner_bin_height, d=inner_bin_inner_diameter);
        
        // Add side holes that align with outer bin
        for(row = [0:hole_rows-1]) {
            // Use the same hole pattern as the outer bin
            usable_height = bin_height - 2*side_hole_edge_margin;
            row_z = side_hole_edge_margin + (usable_height * (row + 0.5) / hole_rows);
            
            // Skip holes that would be above the inner bin height
            if (row_z < inner_bin_height) {
                row_offset = (row % 2) * hole_offset;
                
                for(i = [0:holes_per_row-1]) {
                    angle = (i * 360 / holes_per_row) + (row_offset * (360 / holes_per_row));
                    translate([
                        (inner_bin_outer_diameter/2) * cos(angle),
                        (inner_bin_outer_diameter/2) * sin(angle),
                        row_z
                    ])
                    rotate([0, 90, angle])
                        cylinder(h=wall_thickness*2, d=side_hole_diameter, center=true);
                }
            }
        }
        
        // Add bottom holes
        max_radius = (inner_bin_inner_diameter/2 - bottom_hole_edge_margin);
        for(ring = [0:bottom_holes_rings-1]) {
            ring_radius = max_radius * (ring + 1) / (bottom_holes_rings + 1);
            current_holes = bottom_holes_per_ring * (ring + 1);
            
            for(i = [0:current_holes-1]) {
                angle = i * 360 / current_holes;
                translate([
                    ring_radius * cos(angle),
                    ring_radius * sin(angle),
                    0
                ])
                cylinder(h=wall_thickness*2, d=bottom_hole_diameter, center=true);
            }
        }
    }
}

// Render the bin(s)
outer_bin();

// Render inner bin if enabled
if (create_inner_bin) {
    // Position the inner bin next to the outer bin for viewing
    translate([bin_diameter + 20, 0, 0])
        inner_bin();
    
    // Uncomment to see inner bin inside outer bin
    // color("red", 0.5) translate([0, 0, wall_thickness]) inner_bin();
}

/* Usage instructions:
 * 1. Open the Customizer panel in OpenSCAD (View > Customizer)
 * 2. Adjust parameters as needed for your specific requirements
 * 3. The outer bin is designed to stay in the ground as a permanent sheath
 * 4. The inner bin fits precisely inside with a small tolerance for easy removal
 * 5. Alignment tabs ensure proper positioning of holes
 * 6. For a larger bin, consider printing in sections and joining them
 */ 