// ==========================================
// F-14 VARIABLE-SWEEP WING GLOW CONDUIT TRACK
// HIGH-VOLTAGE COLD PLASMA ROUTING MODULE
// ==========================================

$fn = 50; // Smooth curves for flexible link geometry

// --- PHYSICAL PROFILE DIMENSIONS (mm) ---
conduit_outer_d = 22.0;
conduit_inner_d = 16.0;
link_segment_h  = 18.0;
num_links       = 14;     // Total links to bridge the articulating wing joint

// --- COLOR PALETTE ---
conduit_plastic = [0.18, 0.18, 0.18, 1.0]; // Carbon-filled anti-static PEEK polymer
shield_braid    = [0.65, 0.68, 0.70, 0.95]; // Silver-plated EMI grounding shield
silicone_insul  = [0.90, 0.30, 0.10, 1.0]; // High-dielectric orange silicone core
copper_conductor= [0.88, 0.50, 0.20, 1.0]; // Heavy-gauge copper core strand

// ==========================================
// ASSEMBLY MODULE GENERATION
// ==========================================

// 1. Single Articulating Pivot Link Segment
module articulating_link() {
    color(conduit_plastic) {
        difference() {
            union() {
                // Main protective sleeve body cylindrical barrel
                cylinder(d=conduit_outer_d, h=link_segment_h, center=true);
                // Dual external pivot mounting tabs for interlocking joints
                translate([0, conduit_outer_d/2, link_segment_h/2])
                    cube([6, 8, 8], center=true);
                translate([0, -conduit_outer_d/2, link_segment_h/2])
                    cube([6, 8, 8], center=true);
            }
            // Continuous internal cavity bore hole for wire bundle pass-through
            cylinder(d=conduit_inner_d, h=link_segment_h + 2, center=true);
            
            // Recesses for interlocking socket pins from adjacent links
            translate([0, conduit_outer_d/2, -link_segment_h/2])
                rotate([0, 90, 0]) cylinder(d=3.2, h=10, center=true);
            translate([0, -conduit_outer_d/2, -link_segment_h/2])
                rotate([0, 90, 0]) cylinder(d=3.2, h=10, center=true);
        }
    }
}

// 2. High-Voltage High-Frequency Shielded Wire Core Assembly
module coaxial_plasma_cable() {
    rotate([0, 90, 0]) {
        // Outer Orange High-Voltage Silicone Protective Jacket Insulation
        color(silicone_insul) cylinder(d=10, h=num_links * link_segment_h * 0.95, center=true);
        // Interior Silver-Plated Anti-Interference EMI Shield Braid
        translate([0, 0, 1]) color(shield_braid) cylinder(d=7, h=num_links * link_segment_h, center=true);
        // Pure Stranded Copper High-Current Internal Power Core
        translate([0, 0, 2]) color(copper_conductor) cylinder(d=4, h=num_links * link_segment_h + 10, center=true);
    }
}

// 3. Complete Assembled Flexible Wing Bridge System Loop
module complete_wing_bridge() {
    // Generate the interlinked snake-track assembly along a calculated 3D bending curve
    for (i = [0 : num_links - 1]) {
        // Programmatic calculation modeling dynamic wing-sweep angle bend positions
        angle_tilt = sin(i * 12) * 8; 
        radius_arc = i * (link_segment_h - 2.5);
        
        translate([radius_arc, sin(i * 25) * 15, cos(i * 12) * 5])
            rotate([angle_tilt, angle_tilt * 0.5, 0])
            articulating_link();
    }
    
    // Core structural cabling snaking perfectly through the geometric center of the linked track
    translate([ (num_links * (link_segment_h - 2.5))/2 - 5, 0, 0])
        coaxial_plasma_cable();
}

// Execute core rendering tree
complete_wing_bridge();
