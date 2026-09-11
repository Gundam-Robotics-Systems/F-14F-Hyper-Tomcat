// ==========================================
// UNIVAC IX AVIONICS INTEGRATION CORE FRAME
// F-14F TOMCAT MODERNIZATION SYSTEM LAYOUT v2
// ==========================================

$fn = 60; // Render smoothness for cylinders and spheres

// --- SYSTEM PHYSICAL CONSTANTS (mm) ---
bay_width  = 420;  // F-14 Avionics Bay 3A limits
bay_depth  = 300;  // Structural bulkhead depth
bay_height = 250;  // Vertical clearance ceiling

wall_thickness = 4.0; // Weatherproofed aluminum chassis thickness
card_gap       = 25.0; // Airflow/coolant clearance between modules
slider_depth   = 4.5;  // Depth of structural guide rails inside wall matrices
slider_width   = 6.0;  // Opening track width for card PCB slide frames

// --- COMPONENT MODULE FOOTPRINTS [X, Y, Z] ---
univac_ix_dim =; // 36-bit Mainframe Core Fabric Card
hex_logic_dim =; // 16-State Hexadecimal Logic Array
aegis_brg_dim =; // MIL-STD-1397 Network Bridge
weather_dim   =; // Atmospheric Physics Coprocessor

// --- COLOR PALETTE ---
chassis_color  = [0.25, 0.27, 0.30, 0.45]; // Anodized Gray (Transparent to see inside)
slider_color   = [0.15, 0.16, 0.18, 1.0];  // Hardened Titanium Rail Finish
univac_color   = [0.10, 0.35, 0.70, 1.0];  // Deep Navy Blue
hex_color      = [0.80, 0.50, 0.10, 1.0];  // Copper/Gold Amber
aegis_color    = [0.15, 0.65, 0.30, 1.0];  // Tactical Green
weather_color  = [0.45, 0.20, 0.60, 1.0];  // Atmospheric Purple
cooler_color   = [0.20, 0.75, 0.85, 0.8];  // Liquid Vapor Chamber Blue
valve_color    = [0.85, 0.15, 0.15, 1.0];  // Emergency Intake Crimson

// --- CALCULATED POSITION X-CURSORS ---
start_x = -bay_width/2 + wall_thickness + 35;
x_pos_univac = start_x + univac_ix_dim[0]/2;
x_pos_hex    = x_pos_univac + univac_ix_dim[0]/2 + card_gap + hex_logic_dim[0]/2;
x_pos_aegis  = x_pos_hex + hex_logic_dim[0]/2 + card_gap + aegis_brg_dim[0]/2;
x_pos_weather= x_pos_aegis + aegis_brg_dim[0]/2 + card_gap + weather_dim[0]/2;

// ==========================================
// ASSEMBLY MODULES
// ==========================================

// 1. Weatherproof Outer Chassis Shell with Fluid Line Input/Output Valves
module weatherproof_chassis() {
    difference() {
        union() {
            // Outer enclosure block
            color(chassis_color)
            cube([bay_width, bay_depth, bay_height], center=true);
            
            // Add external heavy-duty mounting lugs for F-14 airframe attachment
            for (x = [-bay_width/2, bay_width/2]) {
                for (y = [-bay_depth/3, bay_depth/3]) {
                    translate([x + (x > 0 ? 6 : -6), y, -bay_height/2 + 10])
                        color([0.4, 0.4, 0.4])
                        difference() {
                            cube([12, 25, 20], center=true);
                            rotate([90, 0, 0]) cylinder(d=8, h=30, center=true); // Bolt holes
                        }
                }
            }
            
            // External Quick-Disconnect Liquid Cooling Valves (Intake/Exhaust)
            // Mounted on the right side exterior wall panel
            translate([bay_width/2 + 10, -50, bay_height/4]) rotate([0, 90, 0]) fluid_valve_hardware("INLET");
            translate([bay_width/2 + 10,  50, bay_height/4]) rotate([0, 90, 0]) fluid_valve_hardware("OUTLET");
        }
        
        // Internal hollow space cavity subtraction
        cube([bay_width - (wall_thickness*2), bay_depth - (wall_thickness*2), bay_height - (wall_thickness*2)], center=true);
        
        // Circular cutouts for military circular connectors (Amphenol MIL-DTL-38999) on front panel
        for (i = [-140 : 70 : 140]) {
            translate([i, -(bay_depth/2 + 1), -60])
                rotate([90, 0, 0])
                cylinder(d=35, h=wall_thickness + 4, center=true);
        }
    }
}

// Helper Module: High-Pressure Mechanical Fluid Valve
module fluid_valve_hardware(label) {
    color(valve_color) {
        cylinder(d=18, h=20, center=true); // Main valve collar
        translate([0, 0, 10]) cylinder(d=12, h=15, center=true); // Quick-release nozzle insert
        translate([0, 0, 17]) cylinder(d=6, h=5, center=true);   // Internal fluid bore line
    }
}

// 2. Structural Slide Rails / Card Slot Sliders
module card_slot_sliders() {
    color(slider_color) {
        // Generate paired ceiling and floor tracks for each target component x-coordinate
        card_x_positions = [x_pos_univac, x_pos_hex, x_pos_aegis, x_pos_weather];
        
        for (x = card_x_positions) {
            // Floor tracks
            translate([x, 0, -bay_height/2 + wall_thickness + 4])
                cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
            
            // Ceiling tracks
            translate([x, 0, bay_height/2 - wall_thickness - 16])
                cube([slider_width, bay_depth - (wall_thickness*2) - 10, 8], center=true);
        }
    }
}

// 3. Individual Avionics Modular Cards with Daughterboard Elements
module internal_avionics_cards() {
    // Slot 1: UNIVAC IX Core Recovery Fabric Card
    translate([x_pos_univac, 0, -10]) {
        color(univac_color) cube(univac_ix_dim, center=true);
        // Integrated Thermal Armor Plate
        translate([0, 0, univac_ix_dim[2]/2 + 4]) 
            color(cooler_color) cube([univac_ix_dim[0]-6, univac_ix_dim[1]-10, 8], center=true);
    }
    
    // Slot 2: Hexadecimal Analog Logic Board
    translate([x_pos_hex, 0, -10]) {
        color(hex_color) cube(hex_logic_dim, center=true);
        // Photonic Memory Loop Block Assembly (EDFA Loop Simulation)
        translate([0, hex_logic_dim[1]/4, 30]) 
            color([0.9, 0.9, 0.9]) cube([hex_logic_dim[0]+8, 40, 40], center=true);
    }
    
    // Slot 3: Univac-Aegis MIL-STD-1397 Tactical Network Bridge
    translate([x_pos_aegis, 0, -10]) {
        color(aegis_color) cube(aegis_brg_dim, center=true);
        // Sub-coaxial interface block for Aegis link arrays
        translate([0, -hex_logic_dim[1]/3, 0]) 
            color([0.3, 0.3, 0.3]) cube([aegis_brg_dim[0]+4, 30, 60], center=true);
    }
    
    // Slot 4: Basic Aviation Knowledge Environmental Modeling Core
    translate([x_pos_weather, 0, -10]) {
        color(weather_color) cube(weather_dim, center=true);
        // Isolated sensor parsing array shield box
        translate([0, 0, -40]) 
            color([0.5, 0.5, 0.5]) cube([weather_dim[0]+4, 80, 40], center=true);
    }
}

// 4. Central Liquid Cooling Fluid Routing Block (Vapor Chamber Manifold)
module vapor_chamber_manifold() {
    // Main top structural cooling distribution plate
    color(cooler_color)
    translate([0, 0, bay_height/2 - wall_thickness - 8]) {
        cube([bay_width - 20, bay_depth - 20, 8], center=true);
    }
    
    // Fluid vertical drop heat-sink rails running alongside the tracks to interface with modules
    color([0.15, 0.6, 0.7, 0.7]) {
        card_x_positions = [x_pos_univac, x_pos_hex, x_pos_aegis, x_pos_weather];
        for(x = card_x_positions) {
            // Left flank drop fluid lines
            translate([x - 8, 0, 0]) cube([3, bay_depth - 40, bay_height - 50], center=true);
            // Right flank drop fluid lines
            translate([x + 8, 0, 0]) cube([3, bay_depth - 40, bay_height - 50], center=true);
        }
    }
}

// ==========================================
// RENDER TREE EXECUTION
// ==========================================
union() {
    weatherproof_chassis();
    card_slot_sliders();
    internal_avionics_cards();
    vapor_chamber_manifold();
}
