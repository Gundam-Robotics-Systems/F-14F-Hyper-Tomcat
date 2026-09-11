// ========================================================
// F-14F RETROFIT KIT - AVIONICS CLIMATE CONTROL MODULE
// SOLID-STATE THERMOELECTRIC PELTIER JUNCTION ASSEMBLY
// ========================================================

$fn = 40; // Precision edge smoothing for cooling fin arrays

// --- THERMOELECTRIC UNIT CONSTANTS (mm) ---
peltier_dim  = 40.0;  // Standard industrial military ruggedized TEC footprint
peltier_h    = 3.8;   // Ceramic core element thickness
fin_height   = 25.0;  // Height of anodized thermal dissipation fins
base_plate_w = 120.0; // Complete multi-array block mounting width
base_plate_l = 120.0;

// --- COLOR PALETTE ---
ceramic_white  = [0.95, 0.95, 0.92, 1.0]; // Alumina (Al2O3) Peltier substrate
anodized_black = [0.18, 0.18, 0.20, 1.0]; // High-emissivity black aluminum heat sink
bismuth_tellur = [0.45, 0.47, 0.48, 1.0]; // Internal Bi2Te3 semiconductor pellets
copper_bus     = [0.85, 0.45, 0.20, 1.0]; // Internal power routing bus lines

// ========================================================
// MECHANICAL MODEL COMPONENT ASSEMBLY
// ========================================================

module peltier_climate_assembly() {
    // 1. The Lower Base Mounting Plate (Interfaces with Vapor Chamber Manifold)
    color(anodized_black)
        translate([0, 0, -2.0])
        cube([base_plate_l, base_plate_w, 4.0], center=true);

    // 2. Quad-Array of Solid-State Peltier Modules (Seated in a 2x2 grid matrix)
    for (x_offset = [-25, 25]) {
        for (y_offset = [-25, 25]) {
            translate([x_offset, y_offset, peltier_h/2]) {
                // Top/Bottom Alumina Ceramic Insulator Plates
                color(ceramic_white) cube([peltier_dim, peltier_dim, peltier_h], center=true);
                
                // Internal Semiconductor Matrix (Visible in cross-section / transparency)
                color(bismuth_tellur) %cube([peltier_dim - 2, peltier_dim - 2, peltier_h - 1], center=true);
            }
        }
    }

    // 3. The Upper Heavy-Duty Dissipation Fin Matrix (Replaces old coils)
    translate([0, 0, peltier_h + fin_height/2 + 2.0]) {
        // Fin assembly base slab
        color(anodized_black) cube([base_plate_l, base_plate_w, 4.0], center=true);
        
        // Programmatic generation of vertical cooling fins to maximize surface area
        color(anodized_black) {
            for (x_fin = [-base_plate_l/2 + 5 : 8 : base_plate_l/2 - 5]) {
                translate([x_fin, 0, fin_height/2])
                    cube([2.0, base_plate_w, fin_height], center=true);
            }
        }
    }
    
    // 4. Heavy-Duty Braided High-Current Silicon Power Feed Leads
    color(copper_bus) {
        translate([-base_plate_l/2 - 10, 0, peltier_h/2])
            rotate([0, 90, 0]) cylinder(d=4.5, h=20, center=true);
        translate([-base_plate_l/2 - 10, 15, peltier_h/2])
            rotate([0, 90, 0]) cylinder(d=4.5, h=20, center=true);
    }
}

// Execute active rendering tree module
peltier_climate_assembly();
