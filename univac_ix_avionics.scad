// ==========================================
// UNIVAC IX AVIONICS INTEGRATION CORE FRAME
// F-14F TOMCAT MODERNIZATION SYSTEM LAYOUT
// ==========================================

$fn = 60; // Render smoothness

// --- SYSTEM PHYSICAL CONSTANTS (mm) ---
bay_width  = 420;  // F-14 Avionics Bay 3A limits
bay_depth  = 300;  // Structural bulkhead depth
bay_height = 250;  // Vertical clearance ceiling

wall_thickness = 4.0; // Weatherproofed aluminum chassis thickness
card_gap       = 25.0; // Airflow/coolant clearance between modules

// --- COMPONENT MODULE FOOTPRINTS [X, Y, Z] ---
univac_ix_dim =; // 36-bit Mainframe Core Fabric Card
hex_logic_dim =; // 16-State Hexadecimal Logic Array
aegis_brg_dim =; // MIL-STD-1397 Network Bridge
weather_dim   =; // Atmospheric Physics Coprocessor

// --- COLOR PALETTE ---
chassis_color = [0.25, 0.27, 0.30, 0.4];  // Anodized Gray (Transparent)
univac_color  = [0.10, 0.35, 0.70, 1.0];  // Deep Navy Blue
hex_color     = [0.80, 0.50, 0.10, 1.0];  // Copper/Gold Amber
aegis_color   = [0.15, 0.65, 0.30, 1.0];  // Tactical Green
weather_color = [0.45, 0.20, 0.60, 1.0];  // Atmospheric Purple
cooler_color  = [0.20, 0.75, 0.85, 0.8];  // Liquid Vapor Chamber

// ==========================================
// ASSEMBLY MODULES
// ==========================================

// 1. Weatherproof Outer Chassis Shell
module weatherproof_chassis() {
    color(chassis_color)
    difference() {
        // Outer enclosure block
        cube([bay_width, bay_depth, bay_height], center=true);
        
        // Internal hollow space cavity
        cube([bay_width - (wall_thickness*2), bay_depth - (wall_thickness*2), bay_height - (wall_thickness*2)], center=true);
        
        // Circular cutouts for military circular connectors (Amphenol MIL-DTL-38999)
        for (i = [-120 : 60 : 120]) {
            translate([i, -(bay_depth/2 + 1), -50])
                rotate([90, 0, 0])
                cylinder(d=35, h=wall_thickness + 4, center=true);
        }
    }
    
    // Add external heavy-duty mounting lugs for F-14 airframe attachment
    for (x = [-bay_width/2, bay_width/2]) {
        for (y = [-bay_depth/3, bay_depth/3]) {
            translate([x + (x > 0 ? 6 : -6), y, -bay_height/2 + 10])
                difference() {
                    cube([12, 30, 20], center=true);
                    rotate([0, 90, 0]) cylinder(d=8, h=20, center=true); // Bolt holes
                }
        }
    }
}

// 2. Individual Avionics Modular Cards
module internal_avionics_cards() {
    // Current horizontal layout stack cursor
    start_x = -bay_width/2 + wall_thickness + 20;

    // Slot 1: UNIVAC IX Core Recovery Fabric Card
    translate([start_x + univac_ix_dim[0]/2, 0, -10]) {
        color(univac_color) cube(univac_ix_dim, center=true);
        // Integrated Thermal Armor Layer
        translate([0, 0, univac_ix_dim[2]/2 + 4]) color(cooler_color) cube([univac_ix_dim[0]-10, univac_ix_dim[1]-10, 8], center=true);
    }
    
    // Slot 2: Hexadecimal Analog Logic Board
    translate([start_x + univac_ix_dim[0] + card_gap + hex_logic_dim[0]/2, 0, -10]) {
        color(hex_color) cube(hex_logic_dim, center=true);
        // Photonic Memory Loop Block Assembly
        translate([0, hex_logic_dim[1]/4, 20]) color([0.9, 0.9, 0.9]) cube([20, 40, 30], center=true);
    }
    
    // Slot 3: Univac-Aegis MIL-STD-1397 Tactical Network Bridge
    translate([start_x + univac_ix_dim[0] + hex_logic_dim[0] + (card_gap*2) + aegis_brg_dim[0]/2, 0, -10]) {
        color(aegis_color) cube(aegis_brg_dim, center=true);
    }
    
    // Slot 4: Basic Aviation Knowledge Environmental Modeling Core
    translate([start_x + univac_ix_dim[0] + hex_logic_dim[0] + aegis_brg_dim[0] + (card_gap*3) + weather_dim[0]/2, 0, -10]) {
        color(weather_color) cube(weather_dim, center=true);
    }
}

// 3. Central Liquid Cooling Fluid Routing Block
module vapor_chamber_manifold() {
    color(cooler_color)
    translate([0, 0, bay_height/2 - wall_thickness - 12]) {
        // Main structural cooling distribution plate
        cube([bay_width - 20, bay_depth - 20, 10], center=true);
        
        // Fluid line simulation rails running over slots
        for(x = [-130 : 65 : 130]) {
            translate([x, 0, -50]) cube([6, bay_depth - 40, 100], center=true);
        }
    }
}

// ==========================================
// RENDER TREE EXECUTION
// ==========================================
union() {
    weatherproof_chassis();
    internal_avionics_cards();
    vapor_chamber_manifold();
}
