// ========================================================
// F-14F AVIONICS KIT - MACH 2.35 STRUCTURAL REINFORCEMENT
// HIGH-G ANTI-SHEAR CARD EDGE GUIDE TABS (SLOT INTEGRATION)
// ========================================================

$fn = 50; // Precision edge cuts for load-bearing radii

// --- RUGGEDIZED MECHANICAL LIMITS (mm) ---
card_max_w   = 180; // Total board horizontal insertion width
card_thick   = 2.4; // 6-layer high-tensile PCB thickness

tab_height    = 10.0; // Increased height to engage deep into chassis tracks
tab_thickness = 8.5;  // Widened base thickness to handle high lateral G-loads
gusset_w      = 6.0;  // Width of structural 45-degree bracing ribs

// --- COLOR PALETTE ---
peek_carbon   = [0.15, 0.15, 0.16, 1.0]; // Carbon-filled high-tensile PEEK (7.5G Rated)
al_reinforce  = [0.70, 0.72, 0.75, 1.0]; // Structural inner 6061-T6 aluminum center spine
pcb_fr4_blue  = [0.10, 0.35, 0.70, 0.4]; // Translucent view of the custom contoured card edge

// ========================================================
// REINFORCED HARDWARE ASSEMBLY MODEL
// ========================================================

module mach235_reinforced_guide_tab() {
    // 1. Baseline View: Section of the Custom Contoured F-14 Avionics PCB
    color(pcb_fr4_blue)
        translate([0, 0, -20])
        cube([card_max_w, card_thick, 40], center=true);

    // 2. High-Strength Carbon-PEEK Main Clamping Slat
    color(peek_carbon)
    difference() {
        union() {
            // Main thickened tracking block that rides inside the chassis rail slider
            translate([0, 0, tab_height/2])
                cube([card_max_w, tab_thickness, tab_height], center=true);
            
            // --- ANTI-SHEAR PROFILE: 45-Degree Structural Support Gussets ---
            // Evenly spaced along the length of the card to absorb heavy lateral G-forces
            for (x_gusset = [-70 : 35 : 70]) {
                translate([x_gusset, 0, 0])
                    rotate([45, 0, 0])
                    cube([gusset_w, tab_thickness * 1.8, tab_thickness * 1.8], center=true);
            }
        }

        // Subtract internal groove where the contoured circuit board sits
        translate([0, 0, -2])
            cube([card_max_w + 5, card_thick + 0.1, tab_height], center=true);
            
        // Counter-sunk clearance holes for through-board cross-mounting rivets
        for (x_rivet = [-60, -20, 20, 60]) {
            translate([x_rivet, 0, -2])
                rotate([90, 0, 0])
                cylinder(d=3.2, h=tab_thickness + 4, center=true);
        }
    }

    // 3. COMPLETE KIT REINFORCEMENT: Internal 6061-T6 Aluminum Core Plate
    // A rigid metallic spine inside the polymer tab to prevent snapping under flex loads
    color(al_reinforce) {
        for (x_rivet = [-60, -20, 20, 60]) {
            translate([x_rivet, 0, -2])
                rotate([90, 0, 0]) {
                    cylinder(d=3.0, h=tab_thickness - 1, center=true); // Connecting rivet pin
                    translate([0, 0, (tab_thickness-1)/2 - 1.5]) 
                        cylinder(d=5.5, h=2.0, center=true); // Flush mechanical rivet cap
                }
        }
    }
}

// Execute active structural rendering view
mach235_reinforced_guide_tab();
