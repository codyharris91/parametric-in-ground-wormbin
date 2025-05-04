// In-Ground Worm Bin - Customizer
// Use this file to adjust parameters, then use main.scad to see the assembly

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

/* [Alignment Features] */
// Width of ridge and channel (mm)
ridge_width = 5;
// Depth of ridge (fraction of wall thickness)
ridge_depth_factor = 0.5;
// Number of ridges around circumference
ridge_count = 4;

// Calculated parameters (don't change these)
ridge_depth = outer_wall_thickness * ridge_depth_factor;
inner_diameter = outer_diameter - 2 * (outer_wall_thickness + tolerance);
inner_height = outer_height - outer_wall_thickness;

// Don't render anything in this file
module nothing() {}
nothing();

// Instructions
echo("INSTRUCTIONS:");
echo("1. Adjust parameters above");
echo("2. Click 'Generate' if auto-generate is disabled");
echo("3. Open main.scad to see the assembly with these parameters");
echo("4. To export STL files, run the generate_stl.py script");

// Generate the parameters file automatically when values change
module write_parameters() {
    params_str = str(
        "// In-Ground Worm Bin - Parameters\n",
        "// Shared parameters for all components\n\n",
        "// Outer shell dimensions\n",
        "outer_diameter = ", outer_diameter, "; // mm\n",
        "outer_height = ", outer_height, ";   // mm\n",
        "outer_wall_thickness = ", outer_wall_thickness, "; // mm\n\n",
        "// Tolerance between shells\n",
        "tolerance = ", tolerance, "; // mm - adjust based on your printer's accuracy\n\n",
        "// Ridge and channel dimensions\n",
        "ridge_width = ", ridge_width, "; // mm\n",
        "ridge_depth = ", ridge_depth, "; // Half the depth of outer shell wall\n",
        "ridge_count = ", ridge_count, "; // Number of ridges/channels around the circumference\n\n",
        "// Inner shell dimensions (calculated from outer dimensions and tolerance)\n",
        "inner_diameter = ", inner_diameter, ";\n",
        "inner_height = ", inner_height, "; // Remove tolerance to make tops flush\n"
    );
    
    // Uncomment to debug
    // echo(params_str);
}

write_parameters(); 