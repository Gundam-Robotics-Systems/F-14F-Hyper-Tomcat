// ========================================================
// F-14F AVIONICS KIT - TACTICAL SEA SPEAR LAUNCH RACK
// TRIPLE-RAIL AGML-XIV ADAPTER FOR BRU-32 INTERFACE
// ========================================================

$fn = 50; // Rendering clarity for cylindrical rocket rails

// --- COMPONENT PARAMETERS (mm) ---
pylon_len  = 220; // Length matching the under-belly tunnel footprint
pylon_w    = 42;  
pylon_h    = 28;  
hook_space = 355.6; // Exact 14-inch NATO standard suspension spacing

// --- BRIMSTONE MISSILE REFERENCE SHAPE DIMENSIONS (mm) ---
missile_len = 180; // 1.8 meter scale scaling down to 1:10 footprint
missile_d   = 18;  // 180mm diameter body shell

// --- COLOR PALETTE ---
composite_gray = [0.35, 0.37, 0.40, 1.0]; // Carbon-fiber RAM infused frame
missile_white  = [0.92, 0.94, 0.95, 1.0]; // Brimstone active body skin
seeker_glass   = [0.20, 0.70, 0.90, 0.6]; // Dual SAL/mmW millimeter radar nose
lug_silver     = [0.75, 0.75, 0.78, 1.0]; // Steel suspension hardware lugs

// ========================================================
// MECHANICAL MODEL COMPONENT ASSEMBLY
// ========================================================

module sea_spear_launcher_assembly() {
    // 1. The Main Aerodynamic Pylon Body Structure
    color(composite_gray)
    difference() {
        hull() {
            cube([pylon_len, pylon_w, pylon_h], center=true);
            // Tapered forward nose cap to reduce drag at Mach 2.35
            translate([pylon_len/2 + 20, 0, 4]) rotate([0, 90, 0]) cylinder(d1=2, d2=pylon_w, h=20, center=true);
        }
        // Hollow internal wiring channel cavity for digital umbilical links
        cube([pylon_len - 10, pylon_w - 8, pylon_h - 6], center=true);
    }

    // --- INTERFACE UPGRADE: 14-Inch BRU-32 Suspension Hooks ---
    // These clip directly into the F-14's existing gas-actuated rack pistons
    color(lug_silver) {
        translate([-hook_space/2, 0, pylon_h/2 + 3]) rotate([90, 0, 90]) cylinder(d=8, h=14, center=true);
        translate([hook_space/2, 0, pylon_h/2 + 3]) rotate([90, 0, 90]) cylinder(d=8, h=14, center=true);
    }

    // 2. Triple Rail Distribution Footprints (Left, Center, Right Launch Tracks)
    // Left Rail Slant Track
    translate([10, -pylon_w * 0.7, -pylon_h * 0.6]) rotate([0, 0, -10]) modular_missile_rail();
    // Center Bottom Track
    translate([10, 0, -pylon_h * 0.8]) modular_missile_rail();
    // Right Rail Slant Track
    translate([10, pylon_w * 0.7, -pylon_h * 0.6]) rotate([0, 0, 10]) modular_missile_rail();
}

// Helper Module: Single Missile Launch Rail with Nested Seated Brimstone
module modular_missile_rail() {
    // Structural launch guide track frame
    color(composite_gray) cube([pylon_len * 0.8, 8, 6], center=true);
    
    // Seated Brimstone Sea Spear Missile Assembly
    translate([15, 0, -missile_d/2 - 3]) {
        rotate([0, 90, 0]) {
            color(missile_white) cylinder(d=missile_d, h=missile_len, center=true); // Missile Body
            translate([0, 0, missile_len/2]) color(seeker_glass) sphere(r=missile_d/2); // mmW Seeker Nose
        }
        // Stabilizing Steering Tail Fins
        for (a = [0 : 90 : 360]) {
            rotate([a, 0, 0]) translate([0, missile_d/2 + 3, -missile_len/2 + 15])
                color(composite_gray) cube([12, 1, 14], center=true);
        }
    }
}

// Execute active rendering tree module
sea_spear_launcher_assembly();
