// ========================================================
// F-14F RETROFIT KIT - AVIONICS INTEGRATION HARDWARE
// EJECTION MONITORING INTERFACE BREAKOUT INTERLOCK PANEL
// ========================================================

$fn = 45; // Smooth render boundaries for circular ports

// --- PANEL PHYSICAL HOUSING CONSTANTS (mm) ---
box_w       = 110; // Compact envelope to mount behind the seat tracking rail
box_l       = 130; 
box_h       = 32;  
wall_thick  = 3.5; // Solid enclosure block protection layer

// --- COLOR PALETTE ---
chem_film_gold  = [0.75, 0.62, 0.20, 1.0]; // MIL-C-5541 conductive gold shield coating
rubber_grommet  = [0.15, 0.15, 0.15, 1.0]; // High-density sealing wire boots
conn_stainless  = [0.80, 0.82, 0.85, 1.0]; // Marine-grade metal circular plugs

// ========================================================
// REINFORCED COMPONENT ASSEMBLY GENERATION
// ========================================================

module ejection_interface_panel() {
    difference() {
        // Main protective housing block shell
        color(chem_film_gold) cube([box_l, box_w, box_h], center=true);
        
        // Internal storage cavity pocket for the telemetry daughterboard
        cube([box_l - (wall_thick*2), box_w - (wall_thick*2), box_h - (wall_thick*2)], center=true);
        
        // Front-panel cutouts for secondary digital monitor hookup plugs
        for (y_pos = [-25, 25]) {
            translate([-box_l/2, y_pos, 0])
                rotate([0, 90, 0]) cylinder(d=22, h=wall_thick * 3, center=true);
        }
        
        // Rear wall port hole for the heavy mechanical umbilical pass-through line
        translate([box_l/2, 0, -box_h/4])
            rotate([0, 90, 0]) cylinder(d=28, h=wall_thick * 3, center=true);
    }
    
    // --- INTEGRATED COMPONENT: Protective Wiring Grommets ---
    // Seals wire exits against cockpit moisture or condensation drops
    color(rubber_grommet) {
        translate([box_l/2 + 2, 0, -box_h/4]) rotate([0, 90, 0]) cylinder(d=32, h=6, center=true);
        translate([box_l/2 + 4, 0, -box_h/4]) rotate([0, 90, 0]) cylinder(d=24, h=10, center=true);
    }
    
    // Input Circular Sensor Coupling Sockets
    color(conn_stainless) {
        for (y_pos = [-25, 25]) {
            translate([-box_l/2 - 2, y_pos, 0])
                rotate([0, 90, 0]) cylinder(d=20, h=8, center=true);
        }
    }
}

// Execute active rendering tree module
ejection_interface_panel();
