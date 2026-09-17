// ========================================================
// F-14F RETROFIT KIT - COCKPIT TACTICAL SATELLITE MODULE
// HIGH-PERFORMANCE SATCOM TRANSEIVER TOWER UPGRADE
// ========================================================

$fn = 50; // Precision render interpolation for RF coax ports

// --- SATCOM MODULE LAYOUT CONSTANTS (mm) ---
// Form-factored to match the exact top profile of the cockpit floor power block
sat_length = 160; 
sat_width  = 90;  
sat_height = 45;  
wall_thick = 4.0; // Mil-spec weatherproofing wall depth

// --- COLOR PALETTE ---
anodized_navy  = [0.12, 0.22, 0.35, 1.0]; // Non-reflective tactical blue finish
gold_rf_shield = [0.88, 0.72, 0.24, 0.4]; // Internally shielded RF processing dome
coax_silver    = [0.82, 0.84, 0.86, 1.0]; // High-frequency external TNC antenna ports
power_pins     = [0.93, 0.83, 0.32, 1.0]; // Direct-coupling basement power contacts

// ========================================================
// MECHANICAL COMPONENT GENERATION
// ========================================================

module satcom_transceiver_assembly() {
    // 1. Reference View: Internal Dual-Mode RF Core Base Substrate
    color(gold_rf_shield)
        translate([0, 0, -5])
        cube([sat_length - 20, sat_width - 20, 12], center=true);

    // 2. Main Weatherproof External Enclosure Chassis Shell
    difference() {
        union() {
            // Main modular block body
            color(anodized_navy) cube([sat_length, sat_width, sat_height], center=true);
            
            // Longitudinal Heat dissipation cooling fins
            color(anodized_navy) {
                for (x_fin = [-sat_length/2 + 15 : 12 : sat_length/2 - 15]) {
                    translate([x_fin, 0, sat_height/2 + 3])
                        cube([2.0, sat_width - 10, 6], center=true);
                }
            }
            
            // --- DROP-IN MATCH: Basement Alignment Interlock Alignment Dowels ---
            // Snaps directly into the underlying cockpit power block screws for stack configuration
            color([0.4, 0.4, 0.4]) {
                translate([-60, -35, -sat_height/2 - 3]) cylinder(d=5, h=6, center=true);
                translate([60,  -35, -sat_height/2 - 3]) cylinder(d=5, h=6, center=true);
                translate([-60,  35, -sat_height/2 - 3]) cylinder(d=5, h=6, center=true);
                translate([60,   35, -sat_height/2 - 3]) cylinder(d=5, h=6, center=true);
            }
        }
        
        // Internal data vault containment cavity subtraction
        cube([sat_length - (wall_thick*2), sat_width - (wall_thick*2), sat_height - (wall_thick*2)], center=true);
        
        // Front wall punch-outs for dual TNC external antenna connections (Iridium + Inmarsat paths)
        translate([sat_length/2 + 1, -20, 0]) rotate([0, 90, 0]) cylinder(d=11.2, h=wall_thick * 3, center=true);
        translate([sat_length/2 + 1,  20, 0]) rotate([0, 90, 0]) cylinder(d=11.2, h=wall_thick * 3, center=true);
        
        // Front display diagnostic pinholes for fiber-optic status LEDs
        for (x_led = [-30, 0, 30]) {
            translate([x_led, -sat_width/2 - 1, -10]) rotate() cylinder(d=2.0, h=wall_thick * 3, center=true);
        }
    }
    
    // 3. High-Frequency Threaded TNC Antenna Joint Adapters
    color(coax_silver) {
        translate([sat_length/2 + 4, -20, 0]) rotate([0, 90, 0]) cylinder(d=11.0, h=8, center=true);
        translate([sat_length/2 + 4,  20, 0]) rotate([0, 90, 0]) cylinder(d=11.0, h=8, center=true);
    }
}

// Execute active rendering architecture module
satcom_transceiver_assembly();
