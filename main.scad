// In-Ground Worm Bin - Main Assembly
// Combines all components

include <config/parameters.scad>;
use <components/outer-shell.scad>;
use <components/inner-shell.scad>;

// Render both shells
outer_shell();
translate([0, 0, outer_wall_thickness]) // Position inner shell on the bottom of outer shell
    color("LightGreen") inner_shell();

// Add some basic information
echo("Outer shell diameter: ", outer_diameter, "mm");
echo("Inner shell diameter: ", inner_diameter, "mm");
echo("Gap between shells: ", tolerance, "mm"); 