// ========================================================
// F-14F RETROFIT KIT - STEALTH TACTICAL SATELLITE MODULE
// LOW-OBSERVABLE COCKPIT TRANSCEIVER INTEGRATION v2
// ========================================================

$fn = 50; // Precision edge smoothing for geometric scattering paths

// --- STEALTH MODULAR CONSTANTS (mm) ---
sat_length = 162; // Slightly widened to account for the RAM absorption jacket
sat_width  = 92;  
sat_height = 47;  
wall_thick = 4.0; 
ram_depth  = 1.5;  // Thickness of the integrated radar-absorbent material matrix

// --- COLOR PALETTE ---
ram_stealth_matte = [0.10, 0.10, 0.11, 1.0]; // Non-reflective Carbon-CNT RAM finish
fss_gold_tint     = [0.85, 0.65, 0.15, 0.45]; // Frequency-Selective Surface copper matrix
coax_dark_chrome  = [0.30, 0.32, 0.35, 1.0]; // Low-RCS treated antenna connectors

// ========================================================
// REINFORCED COMPONENT ASSEMBLY GENERATION
// ========================================================

module stealth_satcom_assembly() {
    difference() {
        union() {
            // 1. Core Structural Chassis Body (Aluminum-Billet Base)
            color([0.2, 0.2, 0.2]) cube([sat_length, sat_width, sat_height], center=true);
            
            // 2. INTEGRATED STEALTH RETROFIT: Multi-Layer RAM Absorption Jacket
            // Traps incoming radar signals and converts them to low-grade heat
            color(ram_stealth_matte)
                difference() {
                    cube([sat_length + (ram_depth*2), sat_width + (ram_depth*2), sat_height + (ram_depth*2)], center=true);
                    cube([sat_length - 0.2, sat_width - 0.2, sat_height - 0.2], center=true);
                }
                
            // Low-Profile Angled Thermal Scattering Fins (Scatters radar at odd vectors)
            color(ram_stealth_matte) {
                for (x_fin = [-sat_length/2 + 20 : 15 : sat_length/2 - 20]) {
                    translate([x_fin, 0, sat_height/2 + ram_depth + 3])
                        rotate([0, 15, 0]) // 15-degree radar scattering slant deflection
                        cube([2.0, sat_width - 12, 6], center=true);
                }
            }
        }
        
        // Internal hollow component safety containment cavity subtraction
        cube([sat_length - (wall_thick*2), sat_width - (wall_thick*2), sat_height - (wall_thick*2)], center=true);
        
        // Front wall ports for low-RCS treated antenna connectors
        translate([sat_length/2 + 3, -20, 0]) rotate([0, 90, 0]) cylinder(d=11.2, h=20, center=true);
        translate([sat_length/2 + 3,  20, 0]) rotate([0, 90, 0]) cylinder(d=11.2, h=20, center=true);
    }
    
    // 3. Embedded Frequency-Selective Surface (FSS) Window Dome
    // Electromagnetically opaque to X-band, but perfectly open to L-band satellite frequencies
    color(fss_gold_tint)
        translate([0, 0, -sat_height/4])
        %cube([sat_length - 15, sat_width - 15, 2], center=true);
}

// Execute active structural rendering view
stealth_satcom_assembly();
