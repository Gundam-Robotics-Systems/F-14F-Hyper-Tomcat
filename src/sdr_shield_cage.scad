// ========================================================
// F-14F TACTICAL SDR TRANSCEIVER - EMI SHIELDING CAGE
// MULTI-COMPARTMENT ELECTROSTATIC ISOLATION BLOCK
// ========================================================

$fn = 40; // Precision edge smoothing for internal milling paths

// --- SHIELD CAGE PHYSICAL LIMITS (mm) ---
cage_length = 140;
cage_width  = 95;
cage_height = 14;
wall_thick  = 2.5; // Thickness of the internal isolation walls

// --- COLOR PALETTE ---
chromate_gold = [0.78, 0.64, 0.22, 1.0]; // Chemical-film conductive gold finish
pcb_green     = [0.15, 0.45, 0.25, 0.4]; // Translucent underlying circuit board
rf_connector  = [0.82, 0.84, 0.86, 1.0]; // Stainless steel SMA antenna jacks

// ========================================================
// REINFORCED COMPONENT ASSEMBLY GENERATION
// ========================================================

module sdr_electrostatic_shield() {
    // 1. Reference View: Underlying Transceiver Card Substrate
    color(pcb_green)
        translate([0, 0, -1.2])
        cube([cage_length + 10, cage_width + 10, 2.4], center=true);

    // 2. CNC-Milled Multi-Cavity Shield Structure
    color(chromate_gold)
    difference() {
        // Main solid block frame envelope
        cube([cage_length, cage_width, cage_height], center=true);
        
        // Cavity A: Power Amplifier Section (Isolates high-power output heat/noise)
        translate([-35, 0, wall_thick/2])
            cube([55, cage_width - (wall_thick*2), cage_height], center=true);
            
        // Cavity B: Low Noise Amplifier & Receiver Section
        translate([15, -20, wall_thick/2])
            cube([40, 45, cage_height], center=true);
            
        // Cavity C: Digital Processing & Frequency-Hopping Clock Sync Section
        translate([15, 23, wall_thick/2])
            cube([40, 32, cage_height], center=true);
            
        // Rear punch-outs for edge-mounted SMA RF coaxial antenna jacks
        for (y_conn = [-30, 0, 30]) {
            translate([cage_length/2, y_conn, -cage_height/4])
                rotate([0, 90, 0]) cylinder(d=6.2, h=10, center=true);
        }
    }
    
    // 3. Hardware Assembly Feature: Threaded SMA Coaxial Plugs
    color(rf_connector) {
        for (y_conn = [-30, 0, 30]) {
            translate([cage_length/2 + 4, y_conn, -cage_height/4])
                rotate([0, 90, 0]) {
                    cylinder(d=6.0, h=8, center=true); // Connector barrel
                    translate([0, 0, 4]) cylinder(d=2.5, h=4, center=true); // Center conductor pin
                }
        }
    }
}

// Execute active structural rendering view
sdr_electrostatic_shield();
