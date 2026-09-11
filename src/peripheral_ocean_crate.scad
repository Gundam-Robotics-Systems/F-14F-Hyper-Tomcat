// ========================================================
// F-14F RELIABILITY KIT - PERIPHERALS OCEAN TRANSIT CRATE
// MIL-SPEC RUGGEDIZED MULTI-COMPARTMENT LOGISTICS RECEPTACLE
// ========================================================

$fn = 50; // Rendering fidelity for high-stress container geometry

// --- MASTER CONTAINER VOLUME LIMITS (mm) ---
// Large logistics footprint sized to fit all heavy mechanical and electronic components
crate_interior_w = 680;  
crate_interior_d = 480;  
crate_interior_h = 360;  

wall_thick = 8.0;   // High-impact rotomolded LLDPE shell wall depth
gasket_w   = 6.0;   // High-visibility environmental moisture barrier width

// --- PERIPHERAL COMPONENT POCKET FOOTPRINTS [X, Y, Z] ---
oil_pan_pocket   =;  // Billet Aluminum Oil Pan cavity space
fuel_pump_pocket =;   // Sealed Brushless Fuel Boost Pump cylinder space
sdr_radio_pocket =;  // SDR Radio with EMI Shield Cage
led_pod_pocket   =;    // GaN LED Solid-State Lens Arrays
pylon_rack_space =;   // Triple-Rail Sea Spear Launch Pylon adapter

// --- COLOR PALETTE ---
mil_olive_drab = [0.33, 0.38, 0.28, 1.2];  // Standard tactical military exterior finish
shock_foam     = [0.15, 0.15, 0.17, 0.90]; // Antistatic black protective insert foam
seal_orange    = [0.90, 0.35, 0.10, 1.0];  // High-visibility silicone environmental gasket
hardware_steel = [0.45, 0.47, 0.50, 1.0];  // Heavy stainless steel locking latches
ghost_alloy    = [0.70, 0.75, 0.80, 0.15]; // Translucent view of nested replacement hardware

// ========================================================
// MECHANICAL MODEL ASSEMBLY
// ========================================================

// 1. Heavy-Duty LLDPE Outer Logistics Shell (With reinforced corner stacking lugs)
module rugged_ocean_shell() {
    difference() {
        // Main block enclosing total volume with impact-deflecting beveled edges
        color(mil_olive_drab)
        minkowski() {
            cube([crate_interior_w + (wall_thick*2), crate_interior_d + (wall_thick*2), crate_interior_h + (wall_thick*2)], center=true);
            sphere(r=10.0); // Impact absorption radii
        }
        
        // Master interior hollow containment space
        cube([crate_interior_w, crate_interior_d, crate_interior_h], center=true);
        
        // High-seas split cut line separating upper lid cover from main containment tub
        translate([0, 0, crate_interior_h/3])
            cube([crate_interior_w + 50, crate_interior_d + 50, 4.0], center=true);
    }
    
    // Forklift Skid Rails and Corner Stacking Interlocks (Molded directly into outer plastic)
    color(mil_olive_drab) {
        // Heavy base skids to survive deck sliding
        for (y_skid = [-180, 180]) {
            translate([0, y_skid, -(crate_interior_h/2 + 14)])
                cube([crate_interior_w - 40, 45, 16], center=true);
        }
        // Lid stacking alignment tracks
        for (x_lug = [-280, 280]) {
            for (y_lug = [-180, 180]) {
                translate([x_lug, y_lug, crate_interior_h/2 + 12])
                    cube([40, 40, 14], center=true);
            }
        }
    }
}

// 2. Continuous Saltwater-Proof Air-Tight Silicone Gasket Seal Rim
module saltwater_barrier_gasket() {
    color(seal_orange)
    translate([0, 0, crate_interior_h/3])
        difference() {
            cube([crate_interior_w + wall_thick, crate_interior_d + wall_thick, 5.0], center=true);
            cube([crate_interior_w - 2, crate_interior_d - 2, 8.0], center=true);
        }
}

// 3. Custom CNC-Routed Antistatic Cushion Foam Matrix (Multi-Compartment Core)
module modular_peripheral_foam() {
    color(shock_foam)
    difference() {
        // Solid high-density foam filling the lower base tub block
        translate([0, 0, -crate_interior_h/6])
            cube([crate_interior_w - 4, crate_interior_d - 4, crate_interior_h * 0.65], center=true);
        
        // --- CAVITY 1: CNC-Cut Out for Billet Oil Pan ---
        translate([-160, -90, -40]) cube(oil_pan_pocket, center=true);
        
        // --- CAVITY 2: Circular Drop Hole for Brushless Fuel Pump ---
        translate([160, -130, -20]) cube(fuel_pump_pocket, center=true);
        
        // --- CAVITY 3: Rectangular Slot for SDR Radio Module ---
        translate([160, 20, -65]) cube(sdr_radio_pocket, center=true);
        
        // --- CAVITY 4: Dual Pockets for LED Pod Arrays ---
        translate([260, 150, -55]) cube(led_pod_pocket, center=true);
        translate([160, 150, -55]) cube(led_pod_pocket, center=true);
        
        // --- CAVITY 5: Precision Track for Sea Spear Launch Pylon ---
        translate([-140, 130, -55]) cube(pylon_rack_space, center=true);
        
        // Ground crew grab-notches molded into foam boundaries for rapid parts extraction
        for (x_grab = [-160, 160]) {
            translate([x_grab, -225, -20]) cube([40, 30, 80], center=true);
        }
    }
}

// 4. Heavy-Duty Spring-Loaded Recessed Twist Latches & Pressure Relief Valve
module shipping_hardware_fixtures() {
    color(hardware_steel) {
        // Front Panel Recessed Butterfly Turn-Latches
        for (x_latch = [-220, 0, 220]) {
            translate([x_latch, -(crate_interior_d/2 + 8), crate_interior_h/3]) 
                cube([35, 14, 55], center=true);
        }
        // Side-Panel Spring-Loaded Heavy Lift Handles
        translate([-(crate_interior_w/2 + 8), 0, -20]) cube([14, 90, 45], center=true);
        translate([(crate_interior_w/2 + 8), 0, -20]) cube([14, 90, 45], center=true);
        
        // --- AUTOMATED BREATHER: Dual-Zone Waterproof Pressure Equalization Valve ---
        // Prevents pressure differentials from crushing or bursting seals during cargo transport
        translate([crate_interior_w/2 + 8, -140, crate_interior_h/3])
            rotate([0, 90, 0]) {
                cylinder(d=36, h=12, center=true);
                color([0.9, 0.9, 0.9]) translate([0,0,2]) cylinder(d=22, h=10, center=true);
            }
    }
}

// 5. Visualizer Mockup: Reference Footprints of Seated Parts Inside Nest Matrix
module nested_hardware_reference_ghosts() {
    color(ghost_alloy) {
        translate([-160, -90, -40]) cube(oil_pan_pocket, center=true);
        translate([160, -130, -20]) cube(fuel_pump_pocket, center=true);
        translate([160, 20, -65]) cube(sdr_radio_pocket, center=true);
        translate([260, 150, -55]) cube(led_pod_pocket, center=true);
        translate([160, 150, -55]) cube(led_pod_pocket, center=true);
        translate([-140, 130, -55]) cube(pylon_rack_space, center=true);
    }
}

// ========================================================
// RENDER TREE EXECUTION
// ========================================================
union() {
    rugged_ocean_shell();
    saltwater_barrier_gasket();
    modular_peripheral_foam();
    shipping_hardware_fixtures();
    nested_hardware_reference_ghosts(); // Structural clearance reference boundary layer nodes
}
