#!/usr/bin/env python3
"""
Generate STL files from OpenSCAD files.
This script uses OpenSCAD to generate STL files for all components.
"""

import os
import sys
import subprocess
from pathlib import Path

# Define the project structure
PROJECT_ROOT = Path(__file__).parent.parent
COMPONENTS_DIR = PROJECT_ROOT / "components"
OUTPUT_DIR = PROJECT_ROOT / "stl"
OPENSCAD_CMD = "openscad"  # Change this if openscad is not in your PATH

# Ensure the output directory exists
OUTPUT_DIR.mkdir(exist_ok=True)

# Define the components to generate STL files for
COMPONENTS = [
    {"file": "inner-shell.scad", "output": "inner-shell.stl"},
    {"file": "outer-shell.scad", "output": "outer-shell.stl"},
]

def check_openscad():
    """Check if OpenSCAD is available."""
    try:
        subprocess.run([OPENSCAD_CMD, "--version"], 
                      stdout=subprocess.PIPE, 
                      stderr=subprocess.PIPE, 
                      check=True)
        return True
    except (subprocess.SubprocessError, FileNotFoundError):
        return False

def generate_stl(input_file, output_file):
    """Generate an STL file from an OpenSCAD file."""
    input_path = COMPONENTS_DIR / input_file
    output_path = OUTPUT_DIR / output_file
    
    print(f"Generating {output_path} from {input_path}...")
    
    try:
        subprocess.run([
            OPENSCAD_CMD,
            "-o", str(output_path),
            str(input_path)
        ], check=True)
        print(f"Successfully generated {output_path}")
        return True
    except subprocess.SubprocessError as e:
        print(f"Error generating {output_path}: {e}")
        return False

def main():
    """Main function to generate STL files."""
    if not check_openscad():
        print("Error: OpenSCAD not found. Please install OpenSCAD or update the OPENSCAD_CMD variable.")
        return 1
    
    success = True
    for component in COMPONENTS:
        if not generate_stl(component["file"], component["output"]):
            success = False
    
    # Also generate a complete model STL if needed
    # generate_stl("../main.scad", "complete_model.stl")
    
    if success:
        print("\nAll STL files generated successfully!")
        print(f"STL files are located in: {OUTPUT_DIR}")
        return 0
    else:
        print("\nSome errors occurred during STL generation.")
        return 1

if __name__ == "__main__":
    sys.exit(main()) 