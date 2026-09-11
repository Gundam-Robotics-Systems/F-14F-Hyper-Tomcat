// ========================================================
// F-14F AVIONICS UPGRADE KIT - PROFILE-CONTOURED MODULES
// CUSTOM PCB SUBSTRATE SHAPES FOR DROP-IN HOUSING TRAY
// ========================================================

$fn = 40; // Manufacturing-grade edge smoothness

// --- CHASSIS SLOT OPERATIONAL CLEARANCES (mm) ---
card_max_w   = 180; // Total horizontal board insertion width
card_max_h   = 160; // Total vertical clearance height
card_thick   = 2.4; // Ruggedized 6-layer high-tensile PCB thickness

chassis_slope_offset = 35; // The structural chamfer to match the sloped fuselage
tab_height           = 6.0; // Alignment rail guide tabs

// --- COMPONENT COLOR DESIGNATIONS ---
univac_blue  = [0.10, 0.35, 0.70, 1.0]; // Slot 1: 36-Bit Core Fabric Substrate
hex_amber    = [0.80, 0.50, 0.10, 1.0]; // Slot 2: 16-State Hexadecimal Logic Array
aegis_green  = [0.15, 0.65, 0.30, 1.0]; // Slot 3: MIL-STD-1397 Tactical Network Bridge
weather_purp = [0.45, 0.20, 0.60, 1.0]; // Slot 4: Atmospheric Physics Coprocessor
gold_conn    = [0.85, 0.72, 0.32, 1.0]; // Rear-facing card-edge backplane socket block

// ========================================================
// GEOMETRIC BOARD ARCHITECTURE EXTRACTION
// ========================================================

// 1. Core Profile Shape Module (Matches the exact sloped F-14 fuselage contour)
module f14_asymmetric_pcb_profile() {
    rotate([90, 0, 90]) // Align vertical into the slide-rail layout
    linear_extrude(height=card_thick, center=true) {
        difference() {
            // Main rectangular board space starting block
            square([card_max_w, card_max_h], center=true);
            
            // DROP-IN SPECIFIC CUT: Asymmetric upper-right corner chamfer 
            // This prevents the board corner from smashing into the sloped exterior skin
            translate([card_max_w/2 - chassis_slope_offset/2 + 1, card_max_h/2 - chassis_slope_offset/2 + 1, 0])
                rotate([0, 0, 45])
                square([chassis_slope_offset * 1.5, chassis_slope_offset * 1.5], center=true);
        }
    }
}

// 2. High-Strength Top and Bottom Card-Edge Rail Guide Tabs
module structural_rail_guides() {
    // Upper guide tab block
    translate([0, 0, card_max_h/2 + tab_height/2])
        cube([card_thick * 2.2, card_max_w - 20, tab_height], center=true);
    // Lower guide tab block
    translate([0, 0, -card_max_h/2 - tab_height/2])
        cube([card_thick * 2.2, card_max_w - 20, tab_height], center=true);
}

// 3. Complete Assembly Breakdown for the 4 Dedicated Modernization Cards
module complete_contoured_avionics_stack() {
    // Card Slot 1: UNIVAC IX Core Recovery Fabric Card
    translate([-60, 0, 0]) {
        color(univac_blue) f14_asymmetric_pcb_profile();
        color([0.2, 0.2, 0.2]) structural_rail_guides();
        // Rear-Facing Blind-Mate Multi-Pin Edge Socket
        translate([0, card_max_w/2 - 5, -20]) color(gold_conn) cube([10, 8, 70], center=true);
    }
    
    // Card Slot 2: Hexadecimal 16-State Analog Logic Board
    translate([-20, 0, 0]) {
        color(hex_amber) f14_asymmetric_pcb_profile();
        color([0.2, 0.2, 0.2]) structural_rail_guides();
        translate([0, card_max_w/2 - 5, -20]) color(gold_conn) cube([10, 8, 70], center=true);
    }
    
    // Card Slot 3: Univac-Aegis MIL-STD-1397 Tactical Network Bridge
    translate([20, 0, 0]) {
        color(aegis_green) f14_asymmetric_pcb_profile();
        color([0.2, 0.2, 0.2]) structural_rail_guides();
        translate([0, card_max_w/2 - 5, -20]) color(gold_conn) cube([10, 8, 70], center=true);
    }
    
    // Card Slot 4: Basic Aviation Knowledge Environmental Modeling Core
    translate([60, 0, 0]) {
        color(weather_purp) f14_asymmetric_pcb_profile();
        color([0.2, 0.2, 0.2]) structural_rail_guides();
        translate([0, card_max_w/2 - 5, -20]) color(gold_conn) cube([10, 8, 70], center=true);
    }
}

// Execute active rendering tree module
complete_contoured_avionics_stack();
