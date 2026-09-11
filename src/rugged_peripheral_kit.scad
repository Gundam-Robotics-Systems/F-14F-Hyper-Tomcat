// ========================================================
// F-14F MODERNIZATION UPGRADE KIT - RUGGED PERIPHERALS
// HIGH-RELIABILITY REPLACEMENT PARTS SPECIFICATION
// ========================================================

$fn = 60; // Manufacturing-grade interpolation curves

// --- COMPONENT GEOMETRIC CONSTANTS (mm) ---
pan_length = 280;  
pan_width  = 180;  
pan_depth  = 65;   
wall_thick = 5.0;  // Thick walls to handle high carrier impact stress

// --- COLOR PALETTE ---
billet_silver = [0.75, 0.78, 0.80, 1.0];  // Anodized 7075-T6 Structural Aluminum
ndfeb_gold    = [0.85, 0.65, 0.15, 1.0];  // Neodymium Magnet Core Trap
pump_teal     = [0.10, 0.50, 0.55, 1.0];  // Sealed Fuel Pump Housing
led_crystal   = [0.90, 0.95, 1.00, 0.6];  // GaN LED Solid-State Lens Matrix

// ========================================================
// REINFORCED COMPONENT ASSEMBLY GENERATION
// ========================================================

// 1. CNC-Milled Billet Aluminum Oil Pan with High-G Reinforcement Ribs
module rugged_oil_pan() {
    difference() {
        union() {
            // Main heavy-duty oil pan tub body
            color(billet_silver) cube([pan_length, pan_width, pan_depth], center=true);
            
            // --- ANTI-CRACKING RESILIENCE: External Cross-Bracing Ribs ---
            // Absorbs violent vertical displacement kinetic energy during carrier trap-downs
            color(billet_silver) {
                for (x_rib = [-100 : 50 : 100]) {
                    translate([x_rib, 0, -pan_depth/2 + 2])
                        cube([6, pan_width + 10, 12], center=true);
                }
            }
        }
        
        // Subtract internal engine oil reservoir cavity volume
        translate([0, 0, wall_thick])
            cube([pan_length - (wall_thick*2), pan_width - (wall_thick*2), pan_depth], center=true);
            
        // Threaded corner interface mounting hole tracks (Fits original block seams)
        for (x_bolt = [-pan_length/2 + 12, pan_length/2 - 12]) {
            for (y_bolt = [-pan_width/2 + 12, pan_width/2 - 12]) {
                translate([x_bolt, y_bolt, pan_depth/2 - 5])
                    cylinder(d=6.5, h=20, center=true);
            }
        }
        
        // Rear basement drain plug port cutout cavity
        translate([pan_length/2 - 30, 0, -pan_depth/2])
            cylinder(d=22, h=wall_thick * 3, center=true);
    }
    
    // --- SUPPLY CHAIN FIX: Integrated Neodymium Magnetic Trap Plug ---
    // Sits directly inside the drain channel to catch circulating engine shavings
    translate([pan_length/2 - 30, 0, -pan_depth/2 - 4]) {
        color([0.3, 0.3, 0.3]) cylinder(d=26, h=6, center=true); // Hex plug cap
        color(ndfeb_gold) translate([0, 0, 12]) cylinder(d=14, h=16, center=true); // Active magnetic core
    }
}

// 2. Brushless Sealed Digital Fuel Pump Module
module sealed_fuel_pump() {
    translate([0, -160, 0]) {
        color(pump_teal) {
            // Main completely sealed cylindrical impeller casing housing
            cylinder(d=64, h=110, center=true);
            // Thickened input/output fuel line distribution flanges
            translate([0, 0, 55]) cylinder(d=24, h=15, center=true);
            translate([0, 32, 0]) rotate([0, 90, 0]) cylinder(d=18, h=20, center=true);
        }
        // Rear Integrated Solid-State Digital Driver Control Cap
        translate([0, 0, -65]) color([0.2, 0.2, 0.2]) cylinder(d=64, h=20, center=true);
    }
}

// 3. High-G Solid-State LED Landing & Formation Light Pod
module solid_state_led_pod() {
    translate([180, 140, 0]) {
        color([0.2, 0.2, 0.2]) cube([45, 65, 25], center=true); // Outer PEEK frame
        
        // 4x High-Efficiency GaN LED Emitter Array
        for (x_led = [-12, 12]) {
            for (y_led = [-18, 18]) {
                translate([x_led, y_led, 8]) {
                    color(led_crystal) sphere(r=8);
                    color([1, 1, 0.9]) translate([0, 0, -4]) cylinder(d=10, h=4, center=true); // Solid core diode
                }
            }
        }
    }
}

// ========================================================
// RENDER TREE EXECUTION
// ========================================================
union() {
    rugged_oil_pan();
    sealed_fuel_pump();
    solid_state_led_pod();
}
