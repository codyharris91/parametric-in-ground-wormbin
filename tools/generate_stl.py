#!/usr/bin/env python3
"""
Generate STL files from OpenSCAD files.
This script uses OpenSCAD to generate STL files for all components.
"""

import os
import sys
import subprocess
import platform
from pathlib import Path

# Define the project structure
PROJECT_ROOT = Path(__file__).parent.parent
COMPONENTS_DIR = PROJECT_ROOT / "components"
OUTPUT_DIR = PROJECT_ROOT / "stl"

# Ensure the output directory exists
OUTPUT_DIR.mkdir(exist_ok=True)

# Define the components to generate STL files for
COMPONENTS = [
    {"file": "inner-shell.scad", "output": "inner-shell.stl", "module": "inner_shell"},
    {"file": "outer-shell.scad", "output": "outer-shell.stl", "module": "outer_shell"},
]

def find_openscad():
    """Try to find OpenSCAD installation on the system."""
    # First try the PATH
    try:
        subprocess.run(["openscad", "--version"], 
                      stdout=subprocess.PIPE, 
                      stderr=subprocess.PIPE, 
                      check=True)
        return "openscad"
    except (subprocess.SubprocessError, FileNotFoundError):
        pass
    
    # If not in PATH, try common installation locations based on OS
    system = platform.system()
    
    if system == "Windows":
        # Common Windows installation paths
        paths = [
            r"C:\Program Files\OpenSCAD\openscad.exe",
            r"C:\Program Files (x86)\OpenSCAD\openscad.exe",
        ]
        for path in paths:
            if os.path.exists(path):
                return path
                
    elif system == "Darwin":  # macOS
        # Common macOS installation paths
        paths = [
            "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD",
            os.path.expanduser("~/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"),
        ]
        for path in paths:
            if os.path.exists(path):
                return path
                
    elif system == "Linux":
        # Common Linux installation paths
        paths = [
            "/usr/bin/openscad",
            "/usr/local/bin/openscad",
        ]
        for path in paths:
            if os.path.exists(path):
                return path
    
    # If we get here, we couldn't find OpenSCAD
    return None

def prompt_for_openscad_path():
    """Prompt the user to enter the path to OpenSCAD."""
    print("\nCouldn't find OpenSCAD automatically. Please enter the full path to the OpenSCAD executable:")
    path = input("> ").strip()
    
    if os.path.exists(path):
        return path
    else:
        print(f"Error: The path '{path}' does not exist.")
        return None

def check_openscad(openscad_cmd):
    """Check if OpenSCAD is available at the given path."""
    try:
        subprocess.run([openscad_cmd, "--version"], 
                      stdout=subprocess.PIPE, 
                      stderr=subprocess.PIPE, 
                      check=True)
        return True
    except (subprocess.SubprocessError, FileNotFoundError):
        return False

def generate_stl(openscad_cmd, input_file, output_file, module_name=None):
    """Generate an STL file from an OpenSCAD file."""
    input_path = COMPONENTS_DIR / input_file
    output_path = OUTPUT_DIR / output_file
    
    print(f"Generating {output_path} from {input_path}...")
    
    cmd = [openscad_cmd, "-o", str(output_path)]
    
    # If a specific module is provided, use it
    if module_name:
        cmd.extend(["--export-format=binstl", "-D", f"render_module=\"{module_name}\""])
    
    cmd.append(str(input_path))
    
    try:
        subprocess.run(cmd, check=True)
        print(f"Successfully generated {output_path}")
        return True
    except subprocess.SubprocessError as e:
        print(f"Error generating {output_path}: {e}")
        # Try alternative approach if the first one fails
        if module_name:
            print("Trying alternative approach...")
            try:
                # Create a temporary file that calls the module explicitly
                temp_file = PROJECT_ROOT / "temp.scad"
                with open(temp_file, "w") as f:
                    f.write(f'include "{input_path}";\n{module_name}();')
                
                # Run OpenSCAD on the temporary file
                subprocess.run([
                    openscad_cmd,
                    "-o", str(output_path),
                    str(temp_file)
                ], check=True)
                
                # Remove the temporary file
                os.remove(temp_file)
                
                print(f"Successfully generated {output_path} using alternative approach")
                return True
            except Exception as e2:
                print(f"Alternative approach also failed: {e2}")
                return False
        return False

def main():
    """Main function to generate STL files."""
    # Try to find OpenSCAD
    openscad_cmd = find_openscad()
    
    # If not found automatically, prompt the user
    if not openscad_cmd:
        print("OpenSCAD not found in common locations.")
        openscad_cmd = prompt_for_openscad_path()
        
        if not openscad_cmd:
            print("Error: OpenSCAD path not provided or invalid.")
            return 1
    
    # Verify the OpenSCAD command works
    if not check_openscad(openscad_cmd):
        print(f"Error: OpenSCAD not found at '{openscad_cmd}' or cannot be executed.")
        return 1
    
    print(f"Using OpenSCAD at: {openscad_cmd}")
    
    # Generate STL files
    success = True
    for component in COMPONENTS:
        if not generate_stl(openscad_cmd, component["file"], component["output"], component.get("module")):
            success = False
    
    # Also generate a complete model STL if needed
    # generate_stl(openscad_cmd, "main.scad", "complete_model.stl")
    
    if success:
        print("\nAll STL files generated successfully!")
        print(f"STL files are located in: {OUTPUT_DIR}")
        return 0
    else:
        print("\nSome errors occurred during STL generation.")
        return 1

if __name__ == "__main__":
    sys.exit(main()) 