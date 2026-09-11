// ==========================================
// UNIVAC IX AVIONICS INTEGRATION CORE FRAME
// F-14F TOMCAT DROP-IN RETROFIT LAYOUT v5
// ==========================================

$fn = 60; // Maximum precision rendering for drop-in alignment features

// --- F-14 TOMCAT AVIONICS BAY 3A SPECIFIC CONSTANTS (mm) ---
bay_width  = 440;  // Standardized racking box width including shelf rails
bay_depth  = 320;  // Insertion depth to backplane seating plane
bay_height = 250;  // Vertical clearance ceiling

wall_thickness = 4.0; // Weatherproofed aluminum chassis thickness
card_gap       = 25.0; // Clearance between internal modernization modules
slider_width   = 6.0;  // Opening track width for card PCB slide frames

// --- COMPONENT MODULE FOOTPRINTS [X, Y, Z] ---
univac_ix_dim =; // 36-bit Mainframe Core Fabric Card
hex_logic_dim =; // 16-State Hexadecimal Logic Array
aegis_brg_dim =; // MIL-STD-1397 Network Bridge
weather_dim   =; // Atmospheric Physics Coprocessor

// --- COLOR PALETTE ---
chassis_color  = [0.25, 0.27, 0.30, 0.20]; // Translucent Anodized Slate Gray
slider_color   = [0.15, 0.16, 0.18, 1.0];  // Hardened Titanium Rail Finish
univac_color   = [0.10, 0.35, 0.70, 0.9];  // Deep Navy Blue
hex_color      = [0.80, 0.50, 0.10, 0.9];  // Copper/Gold Amber
aegis_color    = [0.15, 0.65, 0.30, 0.9];  // Tactical Green
weather_color  = [0.45, 0.20, 0.60, 0.9];  // Atmospheric Purple
cooler_color   = [0.20, 0.75, 0.85, 0.6];  // Liquid Vapor Chamber Blue
handle_color   = [0.75, 0.75, 0.75, 1.0];  // Brushed Stainless Steel

// --- DROP-IN CONNECTOR & RETROFIT COLORS ---
arinc_shell_color = [0.45, 0.43, 0.40, 1.0]; // Chemical-film gold/yellow conductive finish
gold_pin_color    = [0.93, 0.83, 0.32, 1.0]; // Gold-Plated Blind-Mate Pin Blocks
bundle_jacket     = [0.10, 0.10, 0.10, 0.95];// Braided Nomex Wire-Sleeve Black
hydraulic_blue    = [0.0, 0.45, 0.75, 1.0];  // Self-Sealing Fluid Stabs

// --- CALCULATED POSITION X-CURSORS ---
start_x = -bay_width/2 + wall_thickness + 45;
x_pos_univac  = start_x + univac_ix_dim/2;
x_pos_hex     = x_pos_univac + univac_ix_dim/2 + card_gap + hex_logic_dim/2;
x_pos_aegis   = x_pos_hex + hex_logic_dim/2 + card_gap + aegis_brg_dim/2;
x_pos_weather = x_pos_aegis + aegis_brg_dim/2 + card_gap + weather_dim/2;

card_x_positions = [x_pos_univac, x_pos_hex, x_pos_aegis, x_pos_weather];

// ==========================================
// ASSEMBLY MODULES
// ==========================================

// 1. Weatherproof Outer Chassis Shell with F-14 Fuselage Shelf Rails
module weatherproof_chassis() {
    difference() {
        union() {
            // Main box chassis body
            color(chassis_color)
            cube([bay_width - 40, bay_depth, bay_height], center=true);
            
            // --- DROP-IN FEATURE: F-14 Fuselage NATO Side Shelf Mounting Rails ---
            // Continuous side rails that slide directly into the jet's existing electronics bay tracks
            color([0.5, 0.5, 0.5]) {
                // Left mounting rail track flange
                translate([-(bay_width - 40)/2 - 10, 0, -bay_height/4])
                    cube([20, bay_depth - 10, 12], center=true);
                // Right mounting rail track flange
                translate([(bay_width - 40)/2 + 10, 0, -bay_height/4])
                    cube([20, bay_depth - 10, 12], center=true);
            }
        }
        
        // Internal hollow space cavity subtraction
        cube([bay_width - 40 - (wall_thickness*2), bay_depth - (wall_thickness*2), bay_height - (wall_thickness*2)], center=true);
        
        // Rear wall punch-outs for ARINC 404A blind-mate floating connection blocks
        for (x_offset = [-100, 0, 100]) {
            translate([x_offset, bay_depth/2 + 1, -40])
                cube([65, wall_thickness + 4, 35], center=true);
        }
        
        // Rear wall punch-outs for the fluid quick-disconnect coolant stabs
        for (x_fluid = [-50, 50]) {
            translate([x_fluid, bay_depth/2 + 1, 40])
                rotate([90, 0, 0]) cylinder(d=26, h=wall_thickness + 4, center=true);
        }
    }
}

// 2. DROP-IN FEATURE: ARINC 404A Rear Floating Blind-Mate Connectors
// These slide into the jet's backplane receptacle automatically upon tray insertion
module arinc_404_blind_mate_rear() {
    for (x_offset = [-100, 0, 100]) {
        translate([x_offset, bay_depth/2, -40]) {
            // Main Polarized Aligned Shell Housing
            color(arinc_shell_color) {
                cube([72, 8, 42], center=true); // Flange perimeter
                translate([0, 6, 0]) cube([60, 12, 32], center=true); // Direct mating plug nose
            }
            
            // Floating Alignment Guide Pins (Ensures perfect mate even with slight installation offset)
            color([0.7, 0.7, 0.7]) {
                translate([-31, 10, 0]) rotate([90, 0, 0]) cylinder(d=4, h=25, center=true);
                translate([31, 10, 0]) rotate([90, 0, 0]) cylinder(d=4, h=25, center=true);
            }
            
            // Internal High-Density Micro-Pin Modules (Power, Coax, Signal blocks)
            translate([0, 6, 0]) {
                for (z_row = [-10 : 5 : 10]) {
                    for (x_col = [-24 : 4 : 24]) {
                        translate([x_col, 4, z_row])
                            color(gold_pin_color) rotate([90, 0, 0]) cylinder(d=0.8, h=6, center=true);
                    }
                }
            }
        }
    }
}

// 3. DROP-IN FEATURE: Self-Sealing Concentric Liquid Cooling Disconnect Stabs
// Snaps securely into the F-14's airframe coolant manifold automatically
module arinc_fluid_stabs() {
    for (x_fluid = [-50, 50]) {
        translate([x_fluid, bay_depth/2, 40]) {
            rotate([90, 0, 0]) {
                // Outer heavy-duty sealing lock sleeve
                color([0.3, 0.3, 0.3]) cylinder(d=24, h=12, center=true);
                // Self-sealing slider nozzle probe
                translate([0, 0, 12]) color(hydraulic_blue) cylinder(d=16, h=16, center=true);
                // Internal spring-loaded center bypass stem valve
                translate([0, 0, 18]) color([0.8, 0.8, 0.8]) cylinder(d=6, h=10, center=true);
            }
        }
    }
}

// 4. Internal Backplane Wire-Harness Interface Matrix
module internal_backplane_wiring() {
    // Collects all wires bundle straight out from the rear ARINC connector blocks inside the box
    for (x_offset = [-100, 0, 100]) {
        color(bundle_jacket) {
            translate([x_offset, bay_depth/2 - 25, -40])
                cube([50, 30, 20], center=true);
        }
    }
    
    // Distributes individual heavy-gauge data trunks to the bottom of the internal card rails
    color(bundle_jacket) {
        translate([0, bay_depth/4, -70])
            cube([bay_width - 80, 12, 12], center=true);
        
        for (x = card_x_positions) {
            translate([x, bay_depth/4, -70])
                rotate([0, 0, 90]) cylinder(d=8, h=60, center=true);
        }
    }
}

// 5. Structural Slide Rails / Card Slot Sliders
module card_slot_sliders() {
    color(slider_color) {
        for (x = card_x_positions) {
            translate([x, 0, -bay_height/2 + wall_thickness + 4])
                cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
            translate([x, 0, bay_height/2 - wall_thickness - 16])
                cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
        }
    }
}

// 6. Front Panel Quick-Extraction Pull Insertion Handles
module front_panel_latches() {
    color(handle_color) {
        for (x = card_x_positions) {
            translate([x, -bay_depth/2 + 4, -10]) {
                cube([4, 10, 60], center=true);
                translate([0, -6, 25]) cube([4, 16, 6], center=true);
                translate([0, -6, -25]) cube([4, 16, 6], center=true);
                translate([0, -3, 0]) color([0.8, 0.1, 0.1]) rotate([0, 90, 0]) cylinder(d=5, h=4, center=true);
            }
        }
    }
}

// 7. Core Modernization Avionics Stack (Slots 1, 2, 3, 4 Loaded)
module active_avionics_stack() {
    // Slot 1: UNIVAC IX Core Recovery Fabric Card
    translate([x_pos_univac, 0, -10]) color(univac_color) cube(univac_ix_dim, center=true);
    
    // Slot 2: Hexadecimal 16-State Analog Logic Board
    translate([x_pos_hex, 0, -10]) color(hex_color) cube(hex_logic_dim, center=true);
    
    // Slot 3: Univac-Aegis MIL-STD-1397 Tactical Network Bridge
    translate([x_pos_aegis, 0, -10]) color(aegis_color) cube(aegis_brg_dim, center=true);
    
    // Slot 4: Basic Aviation Knowledge Environmental Modeling Core
    translate([x_pos_weather, 0, -10]) color(weather_color) cube(weather_dim, center=true);
    
    // Fluid vertical drop heat-sink rails feeding from the rear manifold down over modules
    color(cooler_color) {
        for(x = card_x_positions) {
            translate([x - 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);
            translate([x + 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);
        }
    }
}

// ==========================================
// RENDER TREE EXECUTION
// ==========================================
union() {
    weatherproof_chassis();
    arinc_404_blind_mate_rear(); // Automated alignment data interface array
    arinc_fluid_stabs();          // Plug-and-play internal cooling loop hookups
    internal_backplane_wiring();
    card_slot_sliders();
    front_panel_latches();
    active_avionics_stack();
}
