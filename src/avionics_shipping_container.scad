// ========================================================
// F-14F AVIONICS MODERNIZATION RETROFIT KIT SHIPPING CASE
// MIL-SPEC RUGGEDIZED TRANSIT & WEATHERPROOF STORAGE CRATE
// ========================================================

$fn = 50; // Smooth corner radii for high-impact edge configurations

// --- INTERNAL KIT SPECIFIC DIMENSIONS (mm) ---
// Sized with clearance to house the 440mm drop-in chassis + 40mm foam buffer
case_interior_w = 520;  
case_interior_d = 400;  
case_interior_h = 320;  

wall_thick = 6.0;   // High-impact polyethylene (LLDPE) outer shell depth
foam_thick = 40.0;  // High-density polyurethane custom-cut safety foam buffer

// --- COLOR PALETTE ---
mil_olive_drab = [0.33, 0.38, 0.28, 1.0];  // Standard tactical military exterior finish
shock_foam     = [0.15, 0.15, 0.15, 0.85]; // Antistatic black protective insert foam
gasket_rubber  = [0.85, 0.15, 0.15, 1.0];  // High-visibility silicone environmental seal
hardware_steel = [0.45, 0.47, 0.50, 1.0];  // Stainless steel latch hinges
chassis_ghost  = [0.20, 0.55, 0.85, 0.25]; // Reference placeholder of nested avionics tray

// ========================================================
// MECHANICAL COMPONENT GENERATION
// ========================================================

// 1. Heavy-Duty Protective Outer Armor Shell (LLDPE Rotomolded Matrix)
module rugged_outer_shell() {
    difference() {
        // Outer raw dimensions block featuring rounded anti-shock corners
        color(mil_olive_drab)
        minkowski() {
            cube([case_interior_w + (wall_thick*2), case_interior_d + (wall_thick*2), case_interior_h + (wall_thick*2)], center=true);
            sphere(r=8.0);
        }
        
        // Internal storage void subtraction cavity
        cube([case_interior_w, case_interior_d, case_interior_h], center=true);
        
        // Split line division cut separating the upper lid layer from the bottom tub frame
        translate([0, 0, case_interior_h/4])
            cube([case_interior_w + 50, case_interior_d + 50, 3.0], center=true);
    }
    
    // Add external structural alignment stacking ridges (Molded top/bottom ribs)
    color(mil_olive_drab) {
        for (x_rib = [-200, 0, 200]) {
            // Lid strengthening ribs
            translate([x_rib, 0, case_interior_h/2 + 8])
                cube([30, case_interior_d - 40, 12], center=true);
            // Base feet tracks
            translate([x_rib, 0, -(case_interior_h/2 + 12)])
                cube([30, case_interior_d - 40, 12], center=true);
        }
    }
}

// 2. Continuous Environmental Silicone Gasket Rim (Water/Air-Tight Seal)
module environmental_seal_gasket() {
    color(gasket_rubber)
    translate([0, 0, case_interior_h/4])
        difference() {
            cube([case_interior_w + wall_thick, case_interior_d + wall_thick, 4.0], center=true);
            cube([case_interior_w - 2, case_interior_d - 2, 6.0], center=true);
        }
}

// 3. Custom CNC-Routed High-Density Polyurethane Shock Foam Inserts
module micro_cut_shock_foam() {
    color(shock_foam)
    difference() {
        // Main block filling the bottom compartment cavity tub section
        translate([0, 0, -case_interior_h/8])
            cube([case_interior_w - 4, case_interior_d - 4, case_interior_h * 0.75], center=true);
        
        // --- PRECISION FOOTPRINT DROP-IN POCKET ---
        // Cut out to match the exact profile dimensions of our upgrade chassis unit
        cube([442, 322, 252], center=true);
        
        // Side finger relief slots for ground crews to lift the unit out easily
        for (x_notch = [-230, 230]) {
            translate([x_notch, 0, 0]) cube([30, 80, 260], center=true);
        }
    }
}

// 4. Quick-Release Tension Cam-Latches and Automatic Pressure Valve
module hardware_fixtures() {
    color(hardware_steel) {
        // Front Draw-Hook Tension Latches
        translate([-150, -(case_interior_d/2 + 8), case_interior_h/4]) cube([25, 12, 45], center=true);
        translate([150,  -(case_interior_d/2 + 8), case_interior_h/4]) cube([25, 12, 45], center=true);
        
        // Rear Heavy-Duty Spring-Pin Hinge Brackets
        translate([-180, (case_interior_d/2 + 8), case_interior_h/4]) cube([40, 12, 30], center=true);
        translate([180,  (case_interior_d/2 + 8), case_interior_h/4]) cube([40, 12, 30], center=true);
        
        // --- BREATHER HOUSING: Automated GORE-TEX Pressure Equalization Valve ---
        // Normalizes internal air pressure differentials during carrier aircraft cargo transport
        translate([case_interior_w/2 + 8, 0, case_interior_h/4])
            rotate([0, 90, 0]) {
                cylinder(d=32, h=10, center=true); // Outer bezel housing ring
                color([0.9, 0.9, 0.9]) translate([0, 0, 2]) cylinder(d=20, h=8, center=true); // Breathable membrane
            }
    }
}

// 5. Reference Mockup: Visualizing Our Nested Upgrade Box Seated Securely
module nested_avionics_chassis_mockup() {
    color(chassis_ghost)
        cube([440, 320, 250], center=true);
}

// ========================================================
// RENDER TREE EXECUTION
// ========================================================
union() {
    rugged_outer_shell();
    environmental_seal_gasket();
    micro_cut_shock_foam();
    hardware_fixtures();
    nested_avionics_chassis_mockup(); // Visual alignment validation reference node
}
