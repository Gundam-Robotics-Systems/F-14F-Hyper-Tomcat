// ==========================================
// UNIVAC IX AVIONICS INTEGRATION CORE FRAME
// F-14F TOMCAT MODERNIZATION SYSTEM LAYOUT v4
// ==========================================

$fn = 60; // Max render smoothness for intricate high-density connectors and cabling

// --- SYSTEM PHYSICAL CONSTANTS (mm) ---
bay_width  = 420;  // F-14 Avionics Bay 3A limits
bay_depth  = 300;  // Structural bulkhead depth
bay_height = 250;  // Vertical clearance ceiling

wall_thickness = 4.0; // Weatherproofed aluminum chassis thickness
card_gap       = 25.0; // Airflow/coolant clearance between modules
slider_width   = 6.0;  // Opening track width for card PCB slide frames

// --- COMPONENT MODULE FOOTPRINTS [X, Y, Z] ---
univac_ix_dim =; // 36-bit Mainframe Core Fabric Card
hex_logic_dim =; // 16-State Hexadecimal Logic Array
aegis_brg_dim =; // MIL-STD-1397 Network Bridge
weather_dim   =; // Atmospheric Physics Coprocessor

// --- COLOR PALETTE ---
chassis_color  = [0.25, 0.27, 0.30, 0.25]; // Clear Transparent Anodized Gray
slider_color   = [0.15, 0.16, 0.18, 1.0];  // Hardened Titanium Rail Finish
univac_color   = [0.10, 0.35, 0.70, 0.9];  // Deep Navy Blue
hex_color      = [0.80, 0.50, 0.10, 0.9];  // Copper/Gold Amber
aegis_color    = [0.15, 0.65, 0.30, 0.9];  // Tactical Green
weather_color  = [0.45, 0.20, 0.60, 0.9];  // Atmospheric Purple
cooler_color   = [0.20, 0.75, 0.85, 0.7];  // Liquid Vapor Chamber Blue
valve_color    = [0.85, 0.15, 0.15, 1.0];  // Emergency Intake Crimson
handle_color   = [0.75, 0.75, 0.75, 1.0];  // Brushed Stainless Steel
trace_color    = [0.95, 0.64, 0.37, 1.0];  // Heavy 3oz Copper Tracing

// --- WIRE-HARNESS & CONNECTOR COLORS ---
amphenol_color = [0.35, 0.38, 0.33, 1.0];  // Olive-Drab Cadmium Military Finish
gold_pin_color = [0.93, 0.83, 0.32, 1.0];  // Heavy Gold-Plated Circular Pins
bundle_jacket  = [0.10, 0.10, 0.10, 0.95]; // Braided Nomex Wire-Sleeve Black
wire_data_1    = [0.20, 0.50, 0.90, 1.0];  // Differential Bus Blue
wire_data_2    = [0.90, 0.80, 0.10, 1.0];  // Hex-Logic Clocking Yellow
wire_coax_rf   = [0.70, 0.70, 0.70, 1.0];  // High-Frequency Silver Coaxial Shield

// --- CALCULATED POSITION X-CURSORS ---
start_x = -bay_width/2 + wall_thickness + 35;
x_pos_univac  = start_x + univac_ix_dim/2;
x_pos_hex     = x_pos_univac + univac_ix_dim/2 + card_gap + hex_logic_dim/2;
x_pos_aegis   = x_pos_hex + hex_logic_dim/2 + card_gap + aegis_brg_dim/2;
x_pos_weather = x_pos_aegis + aegis_brg_dim/2 + card_gap + weather_dim/2;

card_x_positions = [x_pos_univac, x_pos_hex, x_pos_aegis, x_pos_weather];
connector_x_positions = [-140, -70, 0, 70, 140]; // Front panel placement grid

// ==========================================
// ASSEMBLY MODULES
// ==========================================

// 1. Weatherproof Outer Chassis Shell with Fluid Line Valves
module weatherproof_chassis() {
    difference() {
        union() {
            // Outer enclosure block
            color(chassis_color)
            cube([bay_width, bay_depth, bay_height], center=true);
            
            // External heavy-duty mounting lugs for F-14 airframe attachment
            for (x = [-bay_width/2, bay_width/2]) {
                for (y = [-bay_depth/3, bay_depth/3]) {
                    translate([x + (x > 0 ? 6 : -6), y, -bay_height/2 + 10])
                        color([0.4, 0.4, 0.4])
                        difference() {
                            cube(, center=true);
                            rotate() cylinder(d=8, h=40, center=true);
                        }
                }
            }
            
            // External Quick-Disconnect Liquid Cooling Valves (Intake/Exhaust)
            translate([bay_width/2 + 10, -50, bay_height/4]) rotate() fluid_valve_hardware();
            translate([bay_width/2 + 10,  50, bay_height/4]) rotate() fluid_valve_hardware();
        }
        
        // Internal hollow space cavity subtraction
        cube([bay_width - (wall_thickness*2), bay_depth - (wall_thickness*2), bay_height - (wall_thickness*2)], center=true);
        
        // Circular cutouts for military circular connectors on front panel
        for (x_conn = connector_x_positions) {
            translate([x_conn, -(bay_depth/2 + 1), -60])
                rotate()
                cylinder(d=35, h=wall_thickness + 4, center=true);
        }
    }
}

// Helper Module: High-Pressure Mechanical Fluid Valve
module fluid_valve_hardware() {
    color(valve_color) {
        cylinder(d=18, h=20, center=true);
        translate() cylinder(d=12, h=15, center=true);
        translate() cylinder(d=6, h=5, center=true);
    }
}

// 2. Amphenol MIL-DTL-38999 Series III Connectors with Internal Pin Blocks
module amphenol_connector_assembly() {
    for (x_conn = connector_x_positions) {
        translate([x_conn, -bay_depth/2, -60]) {
            rotate() {
                // Outer Hexagonal Coupling Nut and Thread Ring
                color(amphenol_color) {
                    cylinder(d=42, h=6, center=true); // Flange plate
                    translate() cylinder(d=34, h=22, center=true); // Threaded main barrel
                }
                
                // Rear Blue Weatherproof Environment Boot Seal Gland
                translate() color([0.1, 0.4, 0.8, 0.9]) cylinder(d=32, h=8, center=true);
                
                // Rigid Rigid Insulation Pin Insert Block
                translate() color([0.15, 0.15, 0.15]) cylinder(d=28, h=12, center=true);
                
                // Internal Matrix of High-Density Gold-Plated Contact Pins
                translate() {
                    for(r =) {
                        for(a = [0 : 45 : 360]) {
                            rotate([0, 0, a]) translate([r, 0, 0])
                                color(gold_pin_color) cylinder(d=1.2, h=16, center=true);
                        }
                    }
                }
            }
        }
    }
}

// 3. Complex 3D Avionics Wire-Harness & Coaxial Bundle Routing Tree
module wire_harness_routing_matrix() {
    // A. Front Main Interconnect Trunk Line (Snakes horizontally below the slots)
    color(bundle_jacket) {
        translate([0, -bay_depth/2 + 30, -60])
            rotate([0, 90, 0]) cylinder(d=22, h=bay_width - 50, center=true);
    }
    
    // B. Individual Discrete Connector Drop Cables (Feeds from back of Amphenol Plugs into main trunk)
    for (x_conn = connector_x_positions) {
        color(bundle_jacket) {
            translate([x_conn, -bay_depth/2 + 15, -60])
                rotate([90, 0, 0]) cylinder(d=14, h=30, center=true);
        }
    }
    
    // C. Internal Modular Backplane Card Interconnect Wire Looping Tree
    for (i = [0 : len(card_x_positions) - 1]) {
        x_target = card_x_positions[i];
        
        // Data Harness Drops (Snaking from base trunk straight up to modular card face inputs)
        color(wire_data_1) {
            translate([x_target - 4, -bay_depth/2 + 40, -60])
                cube([2.5, 4, 30], center=true);
            translate([x_target - 4, -bay_depth/2 + 55, -45])
                rotate([45, 0, 0]) cube([2.5, 4, 35], center=true);
            translate([x_target - 4, -bay_depth/2 + 65, -30])
                rotate([90, 0, 0]) cylinder(d=2.5, h=20, center=true);
        }
        
        // Clock & Timing Lines Sub-Harness
        color(wire_data_2) {
            translate([x_target + 4, -bay_depth/2 + 40, -60])
                cube([2.0, 4, 30], center=true);
            translate([x_target + 4, -bay_depth/2 + 55, -45])
                rotate([45, 0, 0]) cube([2.0, 4, 35], center=true);
            translate([x_target + 4, -bay_depth/2 + 75, -30])
                rotate([90, 0, 0]) cylinder(d=2.0, h=40, center=true);
        }
        
        // D. Heavy-Duty Braided Backplane Coaxial Cables (Exclusive RF lines for Aegis and Weather telemetry)
        if (x_target == x_pos_aegis || x_target == x_pos_weather) {
            color(wire_coax_rf) {
                // High-flex sweeping 3D arc mapping to back wall distribution blocks
                translate([x_target, 0, -80])
                    rotate([90, 0, 90]) cylinder(d=4.5, h=80, center=true);
                translate([x_target + 40, 40, -80])
                    rotate([0, 45, 45]) cylinder(d=4.5, h=40, center=true);
                // Secure metal coax tie-down clamps
                translate([x_target + 40, 40, -80])
                    color([0.6, 0.6, 0.6]) cube([8, 8, 6], center=true);
            }
        }
    }
}

// 4. Structural Slide Rails / Card Slot Sliders
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

// 5. Front Panel Quick-Extraction Maintenance Latches
module front_panel_latches() {
    color(handle_color) {
        for (x = card_x_positions) {
            translate([x, -bay_depth/2 + 4, -10]) {
                cube([6, 8, 80], center=true);
                translate([0, 4, 40]) cube([6, 12, 12], center=true);
                translate([0, 4, -40]) cube([6, 12, 12], center=true);
                translate([0, -3, 0]) color([0.8, 0.1, 0.1]) rotate([90, 0, 0]) cylinder(d=5, h=4, center=true);
            }
        }
    }
}

// 6. Detailed Component Internal Breakdown (Slot 2: Hexadecimal Platform Focus)
module hexadecimal_board_breakdown() {
    translate([x_pos_hex, 0, -10]) {
        color(hex_color) cube(hex_logic_dim, center=true);
        for (y_offset = [-60, 0, 60]) {
            translate([0, y_offset, 10]) {color([0.15, 0.15, 0.15]) cube([45, 45, 12], center=true);translate([0, 0, 7.5]) color([0.8, 0.8, 0.8]) cube([35, 35, 3], center=true);color([0.9, 0.7, 0.2]) difference() {cube([55, 55, 6], center=true);cube([49, 49, 8], center=true);}}}color(trace_color) {for (z_line = [-50 : 25 : 50]) {translate([22.5, 0, z_line]) cube([1, 180, 2.5], center=true);translate([22.5, 80, z_line]) rotate([0, 0, 45]) cube([1, 40, 2.5], center=true);}}}}// 7. Standard Modular Slot Cards (Slots 1, 3, 4)module standard_avionics_cards() {translate([x_pos_univac, 0, -10]) {color(univac_color) cube(univac_ix_dim, center=true);translate([0, 0, univac_ix_dim/2 + 4])color(cooler_color) cube([univac_ix_dim-4, univac_ix_dim-10, 8], center=true);}translate([x_pos_aegis, 0, -10]) {color(aegis_color) cube(aegis_brg_dim, center=true);translate([0, -aegis_brg_dim/3, 0])color([0.3, 0.3, 0.3]) cube([aegis_brg_dim+4, 30, 60], center=true);}translate([x_pos_weather, 0, -10]) {color(weather_color) cube(weather_dim, center=true);translate([0, 0, -40])color([0.5, 0.5, 0.5]) cube([weather_dim+4, 80, 40], center=true);}}// 8. Central Liquid Cooling Fluid Routing Block (Vapor Chamber Manifold)module vapor_chamber_manifold() {color(cooler_color)translate([0, 0, bay_height/2 - wall_thickness - 8]) {cube([bay_width - 20, bay_depth - 20, 8], center=true);}color([0.15, 0.6, 0.7, 0.5]) {for(x = card_x_positions) {translate([x - 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);translate([x + 6, 0, 0]) cube([2, bay_depth - 40, bay_height - 50], center=true);}}}// ==========================================// RENDER TREE EXECUTION// ==========================================union() {weatherproof_chassis();amphenol_connector_assembly();wire_harness_routing_matrix();card_slot_sliders();front_panel_latches();hexadecimal_board_breakdown();standard_avionics_cards();vapor_chamber_manifold();}
