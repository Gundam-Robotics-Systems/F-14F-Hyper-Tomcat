// ==========================================
// UNIVAC IX AVIONICS INTEGRATION CORE FRAME
// F-14F TOMCAT ALL-IN-ONE RETROFIT KIT v6
// ==========================================

$fn = 60; // Production-grade render smoothness for small threaded fasteners

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

// --- KIT & FASTENER SPECIFIC COLORS ---
screw_silver   = [0.82, 0.84, 0.86, 1.0];  // Cadmium-Plated Aerospace Steel
brass_ground   = [0.78, 0.61, 0.26, 1.0];  // Heavy Braided Copper Bonding Strap
arinc_shell    = [0.45, 0.43, 0.40, 1.0];  // Yellow Chromate Shield Finish
gold_pin_color = [0.93, 0.83, 0.32, 1.0];  // Gold Blind-Mate Contacts
bundle_jacket  = [0.10, 0.10, 0.10, 0.95]; // Braided Nomex Wire Sleeve
hydraulic_blue = [0.0, 0.45, 0.75, 1.0];  // Self-Sealing Fluid Stabs

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
            
            // F-14 Fuselage NATO Side Shelf Mounting Rails 
            color([0.5, 0.5, 0.5]) {
                translate([-(bay_width - 40)/2 - 10, 0, -bay_height/4]) cube([20, bay_depth - 10, 12], center=true);
                translate([(bay_width - 40)/2 + 10, 0, -bay_height/4]) cube([20, bay_depth - 10, 12], center=true);
            }
        }
        
        // Internal hollow space cavity subtraction
        cube([bay_width - 40 - (wall_thickness*2), bay_depth - (wall_thickness*2), bay_height - (wall_thickness*2)], center=true);
        
        // Rear wall punch-outs for ARINC 404A blind-mate connection blocks
        for (x_offset = [-100, 0, 100]) {
            translate([x_offset, bay_depth/2 + 1, -40]) cube([65, wall_thickness + 4, 35], center=true);
        }
        
        // Rear wall punch-outs for the fluid quick-disconnect coolant stabs
        for (x_fluid = [-50, 50]) {
            translate([x_fluid, bay_depth/2 + 1, 40]) rotate([90, 0, 0]) cylinder(d=26, h=wall_thickness + 4, center=true);
        }
    }
}

// 2. COMPLETE KIT FEATURE: ARINC Front-Panel Captive Locking Thumbscrews
// These clamp the drop-in box securely onto the aircraft's mounting tray hooks
module arinc_chassis_holddown_screws() {
    color(screw_silver) {
        // Lower Left Hold-Down Assembly
        translate([-(bay_width - 40)/2 + 15, -bay_depth/2 - 12, -bay_height/2 + 15]) holddown_bolt_geometry();
        // Lower Right Hold-Down Assembly
        translate([(bay_width - 40)/2 - 15, -bay_depth/2 - 12, -bay_height/2 + 15]) holddown_bolt_geometry();
    }
}

// Helper Module: MIL-SPEC Hold-Down Mechanism
module holddown_bolt_geometry() {
    rotate([90, 0, 0]) {
        cylinder(d=6, h=24, center=true); // Threaded bolt shank
        translate([0, 0, -12]) cylinder(d=14, h=10, center=true); // Spring casing cylinder
        translate([0, 0, -20]) cube([22, 6, 8], center=true);     // Oversized wing-nut head
    }
}

// 3. COMPLETE KIT FEATURE: Internal Card Lock & PCB Retention Screws
// Ensures individual modules do not shake out of tracks during severe carrier landings
module internal_pcb_retention_screws() {
    color(screw_silver) {
        for (x = card_x_positions) {
            // Top front retention clamping screw
            translate([x, -bay_depth/2 + 12, bay_height/2 - wall_thickness - 6])
                hex_fastener_geometry();
            
            // Bottom front retention clamping screw
            translate([x, -bay_depth/2 + 12, -bay_height/2 + wall_thickness + 12])
                hex_fastener_geometry();
        }
    }
}

// Helper Module: Internal Hex Fastener Head
module hex_fastener_geometry() {
    rotate([90, 0, 0]) {
        cylinder(d=4, h=12, center=true); // Screw pin thread
        translate([0, 0, -6]) cylinder(d=7, h=3, center=true, $fn=6); // Hex socket cap head
    }
}

// 4. COMPLETE KIT FEATURE: Low-Impedance Braided Grounding Strap 
// Critical for electrostatic discharge (ESD) and absolute marine weatherproofing security
module chassis_grounding_strap() {
    color(brass_ground) {
        // Heavy copper braided grounding line snaking from rear wall corner
        translate([-(bay_width - 40)/2 + 8, bay_depth/2 - 20, -bay_height/2 - 10]) {
            // Main flex loop braid
            rotate([0, 35, 0]) cube([4, 12, 45], center=true);
            
            // Chassis grounding terminal lug clamp
            translate([5, 0, 20]) rotate([0, -35, 0]) {
                color(screw_silver) {
                    cylinder(d=12, h=3, center=true); // Washer ring
                    cylinder(d=5, h=10, center=true);  // Bonding frame screw
                }
            }
        }
    }
}

// 5. ARINC 404A Rear Floating Blind-Mate Connectors
module arinc_404_blind_mate_rear() {
    for (x_offset = [-100, 0, 100]) {
        translate([x_offset, bay_depth/2, -40]) {
            color(arinc_shell) {
                cube([60, 6, 30], center=true);
                translate([0, 4, 0]) cube([54, 8, 24], center=true);
            }
            color([0.7, 0.7, 0.7]) {
                translate([-31, 10, 0]) rotate([90, 0, 0]) cylinder(d=4, h=25, center=true);
                translate([31, 10, 0]) rotate([90, 0, 0]) cylinder(d=4, h=25, center=true);
            }
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

// 6. Self-Sealing Concentric Liquid Cooling Disconnect Stabs
module arinc_fluid_stabs() {
    for (x_fluid = [-50, 50]) {
        translate([x_fluid, bay_depth/2, 40]) {
            rotate([90, 0, 0]) {
                color([0.3, 0.3, 0.3]) cylinder(d=24, h=12, center=true);
                translate([0, 0, 8]) color(hydraulic_blue) cylinder(d=16, h=16, center=true);
                translate([0, 0, 14]) color([0.8, 0.8, 0.8]) cylinder(d=6, h=10, center=true);
            }
        }
    }
}

// 7. Internal Backplane Wire-Harness Interface Matrix
module internal_backplane_wiring() {
    for (x_offset = [-100, 0, 100]) {
        color(bundle_jacket) {
            translate([x_offset, bay_depth/2 - 25, -40]) cube([45, 30, 20], center=true);
        }
    }
    color(bundle_jacket) {
        translate([0, bay_depth/4, -70]) cube([bay_width - 80, 12, 12], center=true);
        for (x = card_x_positions) {
            translate([x, bay_depth/4, -70]) rotate([90, 0, 0]) cylinder(d=8, h=60, center=true);
        }
    }
}

// 8. Structural Slide Rails / Card Slot Sliders
module card_slot_sliders() {
    color(slider_color) {
        for (x = card_x_positions) {
            translate([x, 0, -bay_height/2 + wall_thickness + 4]) cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
            translate([x, 0, bay_height/2 - wall_thickness - 16]) cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
        }
    }
}

// 9. Front Panel Quick-Extraction Pull Insertion Handles
module front_panel_latches() {
    color(handle_color) {
        for (x = card_x_positions) {
            translate([x, -bay_depth/2 + 4, -10]) {
                cube([4, 4, 80], center=true);
                translate([0, -6, 25]) cube([4, 12, 4], center=true);
                translate([0, -6, -25]) cube([4, 12, 4], center=true);
                translate([0, -3, 0]) color([0.8, 0.1, 0.1]) rotate([90, 0, 0]) cylinder(d=5, h=4, center=true);
            }
        }
    }
}

// 10. Core Modernization Avionics Stack (Slots 1, 2, 3, 4 Loaded)
module active_avionics_stack() {
    translate([x_pos_univac, 0, -10]) color(univac_color) cube(univac_ix_dim, center=true);
    translate([x_pos_hex, 0, -10]) color(hex_color) cube(hex_logic_dim, center=true);
translate([x_pos_aegis, 0, -10]) color(aegis_color) cube(aegis_brg_dim, center=true);translate([x_pos_weather, 0, -10]) color(weather_color) cube(weather_dim, center=true);color(cooler_color) {for(x = card_x_positions) {translate([x - 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);translate([x + 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);}}}// ==========================================// RENDER TREE EXECUTION// ==========================================union() {weatherproof_chassis();arinc_chassis_holddown_screws();   // Front rack fastenersinternal_pcb_retention_screws();   // Module lock screwschassis_grounding_strap();          // Heavy EMI copper braid bonding linearinc_404_blind_mate_rear();arinc_fluid_stabs();internal_backplane_wiring();card_slot_sliders();front_panel_latches();active_avionics_stack();}
