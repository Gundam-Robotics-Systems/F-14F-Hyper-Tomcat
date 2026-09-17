// ========================================================
// F-14F RETROFIT KIT - COCKPIT POWER DISTRIBUTION SYSTEM
// EXPLOSION-PROOF SOLID-STATE REGULATOR HOUSING ASSEMBLY
// ========================================================

$fn = 50; // High-precision manufacturing corner smoothing

// --- COCKPIT FLOOR RIGHT FLANK SPACE ENVELOPE (mm) ---
block_length = 160; 
block_width  = 90;  
block_height = 55;  
wall_thick   = 5.0; // Reinforced armor wall thickness to fully contain internal faults

fin_h        = 12.0; // Thermal dissipation cooling fins height

// --- COLOR PALETTE ---
tactical_black = [0.15, 0.15, 0.16, 1.0]; // Non-reflective powder-coated armor finish
copper_bus     = [0.85, 0.45, 0.20, 1.0]; // High-current solid copper terminal lugs
conn_stainless = [0.80, 0.82, 0.85, 1.0]; // Sealed MIL-DTL-38999 circular input plugs
fr4_green      = [0.12, 0.44, 0.22, 0.4]; // Translucent view of interior circuit substrate

// ========================================================
// MECHANICAL COMPONENT GENERATION
// ========================================================

module cockpit_power_block_assembly() {
    // 1. Reference View: Internal Solid-State Isolation Circuitry
    color(fr4_green)
        translate([0, 0, -2])
        cube([block_length - 12, block_width - 12, 3], center=true);

    // 2. Heavy-Duty Armor Blast Shell (Milled 6061-T6 Aluminum billet)
    difference() {
        union() {
            // Main protective chassis core envelope
            color(tactical_black) 
                cube([block_length, block_width, block_height], center=true);
            
            // --- THERMAL MITIGATION: Integrated Cooling Fin Rails ---
            // Dissipates power step-down conversion heat without any noisy, high-failure fans
            color(tactical_black) {
                for (y_fin = [-block_width/2 + 8 : 10 : block_width/2 - 8]) {
                    translate([0, y_fin, block_height/2 + fin_h/2])
                        cube([block_length - 20, 2.0, fin_h], center=true);
                }
            }
            
            // Non-Destructive Side Mounting Slat Flanges
            // Fastens directly into the original right-hand console utility tracks
            color(tactical_black) {
                translate([0, -block_width/2 - 6, -block_height/2 + 4]) cube([block_length - 20, 12, 8], center=true);
                translate([0,  block_width/2 + 6, -block_height/2 + 4]) cube([block_length - 20, 12, 8], center=true);
            }
        }
        
        // Internal hollow component safety containment vault subtraction cavity
        cube([block_length - (wall_thick*2), block_width - (wall_thick*2), block_height - (wall_thick*2)], center=true);
        
        // Front wall punch-outs for the 28V DC input and dual 5V/12V output interface connectors
        translate([-block_length/2, -22, 0]) rotate([0, 90, 0]) cylinder(d=22, h=wall_thick * 3, center=true);
        translate([-block_length/2,  22, 0]) rotate([0, 90, 0]) cylinder(d=22, h=wall_thick * 3, center=true);
        
        // Counter-sunk mounting bolt holes on side flanges to anchor box with no drilling
        for (x_bolt = [-50, 50]) {
            translate([x_bolt, -block_width/2 - 6, -block_height/2 + 4]) cylinder(d=5.5, h=20, center=true);
            translate([x_bolt,  block_width/2 + 6, -block_height/2 + 4]) cylinder(d=5.5, h=20, center=true);
        }
    }
    
    // 3. Sealed Multi-Pin Stainless Connector Shell Ports
    color(conn_stainless) {
        translate([-block_length/2 - 2, -22, 0]) rotate([0, 90, 0]) cylinder(d=20, h=8, center=true); // 28V In
        translate([-block_length/2 - 2,  22, 0]) rotate([0, 90, 0]) cylinder(d=20, h=8, center=true); // Regulated Out
    }
}

// Execute active rendering tree module
cockpit_power_block_assembly();
