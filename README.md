# In-Ground Worm Bin

![In-Ground Worm Bin](images/worm_bin_render.png)

A 3D printable design for an in-ground vermicomposting system that allows for efficient composting of kitchen scraps while providing protection from pests and extreme temperatures.

## About Vermicomposting

Vermicomposting is the process of using worms to transform organic waste into a valuable soil amendment. An in-ground worm bin offers several advantages over traditional above-ground systems:

### Benefits of In-Ground Worm Bins

1. **Temperature Stability**: The surrounding soil acts as insulation, protecting worms from temperature extremes
2. **Natural Drainage**: Excess moisture can drain into the surrounding soil
3. **Pest Resistance**: When properly installed, in-ground systems are more resistant to pests
4. **Seamless Integration**: Can be installed in gardens or yards with minimal visual impact
5. **Direct Soil Interaction**: Allows beneficial microorganisms to move between the bin and surrounding soil

## Design Features

- Nested cylindrical design with inner and outer shells
- Alignment ridges and channels to prevent rotation
- Modular design for easy customization
- Solid bottom to prevent unwanted pest entry
- Open top for easy access (can be covered with a separate lid)

## Customization

You can customize the worm bin design by:

1. **Using OpenSCAD Customizer**: Open `main.scad` in OpenSCAD and use the Customizer panel to adjust parameters
2. **Editing Parameters Directly**: Modify the parameters at the top of `main.scad`

Key parameters include:

- `outer_diameter`: Diameter of the outer shell
- `outer_height`: Height of the outer shell
- `outer_wall_thickness`: Wall thickness of both shells
- `tolerance`: Gap between inner and outer shells
- `ridge_width` and `ridge_depth`: Dimensions of alignment features
- `ridge_count`: Number of alignment ridges/channels

## Using the Tools

### Generating STL Files

The project includes a Python script to generate STL files with various quality settings:

```bash
# Basic usage (default quality)
python tools/generate_stl.py

# Generate high-quality STLs (smoother curves, larger files)
python tools/generate_stl.py --quality 200

# Generate low-quality STLs (faster, smaller files)
python tools/generate_stl.py --quality 50

# Generate STLs to a custom location
python tools/generate_stl.py --output-dir "./exports"
```

The quality parameter (`--quality`) controls the smoothness of curved surfaces. Higher values produce smoother curves but take longer to generate and result in larger files.

### Creating a Monolithic File

If you want to share or archive the design as a single file:

```bash
python tools/combine_files.py
```

This will create a single OpenSCAD file in the `build` directory that contains all the code from the separate files combined.

## Materials Considerations

### Food-Safe 3D Printing

When printing components that will be in contact with materials that eventually become compost for growing food, consider these guidelines:

1. **Recommended Materials**:
   - PETG: Good water resistance, durability, and generally considered food-safe
   - PLA: Biodegradable but less durable for long-term outdoor use
   - PP (Polypropylene): Excellent chemical resistance and food safety

2. **Avoid**:
   - ABS: Contains chemicals that may leach into compost
   - Recycled filaments of unknown origin
   - Additives like colorants that aren't food-safe

3. **Print Settings**:
   - Use 100% infill for water-tight results
   - Higher layer heights (0.2-0.3mm) are acceptable and reduce print time
   - Use a larger nozzle (0.6-0.8mm) for stronger parts

4. **Post-Processing**:
   - Consider sealing PLA prints with food-safe epoxy for longer life
   - Sand rough edges for easier cleaning

## Building Instructions

### Printing the Components

1. Generate STL files using the provided script or export directly from OpenSCAD
2. Print with the following recommended settings:
   - Layer Height: 0.2-0.3mm
   - Infill: 80-100%
   - Walls: 3-4 perimeters
   - Nozzle Size: 0.4-0.8mm
   - Material: PETG or PLA (see Materials Considerations)

### Installation

1. **Select Location**:
   - Choose a spot with good drainage
   - Avoid areas that flood or have high water tables
   - Consider accessibility for harvesting compost

2. **Dig the Hole**:
   - Dig a hole slightly larger than the outer shell diameter
   - Depth should match the height of the outer shell
   - Create a flat bottom

3. **Prepare the Base**:
   - Add 2-3 inches of gravel at the bottom for drainage
   - Level the gravel

4. **Install the Outer Shell**:
   - Place the outer shell in the hole
   - Ensure the top is level with or slightly above ground level
   - Backfill around the outside to secure it in place

5. **Prepare the Bedding**:
   - Add 4-6 inches of bedding material (shredded newspaper, coconut coir, etc.)
   - Moisten the bedding (damp as a wrung-out sponge)
   - Add a handful of soil or finished compost

6. **Add Worms**:
   - Add composting worms (Eisenia fetida or "red wigglers" are recommended)
   - 1/2 to 1 pound of worms is a good starting amount
   - Allow worms to settle for a few days before adding food scraps

7. **Insert Inner Shell**:
   - Align the ridges with the channels in the outer shell
   - Gently lower the inner shell into place

8. **Cover**:
   - Use a breathable cover like burlap or a custom 3D printed lid
   - Protect from heavy rain while allowing airflow

## Usage and Maintenance

1. **Feeding**:
   - Add small amounts of kitchen scraps regularly
   - Bury food under bedding to prevent flies
   - Avoid meat, dairy, oils, and citrus in large quantities

2. **Moisture Management**:
   - Keep bedding as moist as a wrung-out sponge
   - Add dry bedding if too wet
   - Sprinkle water if too dry

3. **Harvesting Compost**:
   - After 3-6 months, lift the inner shell to harvest finished compost
   - Replace with fresh bedding and continue the cycle

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by traditional in-ground vermicomposting systems
- Designed to be easily 3D printable with minimal supports

