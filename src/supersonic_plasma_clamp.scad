// ========================================================
// F-14F SUPERSONIC COLD PLASMA ACTUATOR RETENTION CLAMP
// NON-DESTRUCTIVE HIGH-SPEED ANTI-SHEAR COMPRESSION MOUNT
// ========================================================

$fn = 60; // Production smoothness for precision clamping radii

// --- TAIL FIN LEADING EDGE GEOMETRIC PROFILE (mm) ---
airfoil_chord_len = 180;
leading_edge_r    = 8.0;   // F-14 vertical tail fin leading apex radius
clamp_segment_h   = 120;  // Height per modular retention sleeve block
skin_thickness    = 3.0;   // High-strength composite clamp wall thickness

// --- COLOR PALETTE ---
titanium_dark  = [0.28, 0.30, 0.32, 1.0];  // Ti-6Al-4V anti-shear outer frame
kapton_amber   = [0.72, 0.43, 0.12, 0.9];  // Embedded plasma actuator substrate
copper_foil    = [0.85, 0.43, 0.24, 1.0];  // Plasma electrodes
screw_silver   = [0.82, 0.84, 0.86, 1.0];  // High-tensile tension adjustment fasteners
f14_gray       = [0.55, 0.58, 0.62, 0.35]; // Translucent underlying F-14 tail skin

// ========================================================
// MECHANICAL MODEL MODULES
// ========================================================

// 1. Simulated F-14 Tail Fin Structural Leading Edge Apex
module f14_tail_leading_edge() {
    color(f14_gray)
    difference() {
        hull() {
            cylinder(r=leading_edge_r, h=clamp_segment_h + 20, center=true);
            translate([airfoil_chord_len, 0, 0]) 
                cylinder(r=1, h=clamp_segment_h + 20, center=true);
        }
        // Hollow internal skin representation
        translate([5, 0, 0]) hull() {
            cylinder(r=leading_edge_r - 2, h=clamp_segment_h + 30, center=true);
            translate([airfoil_chord_len, 0, 0]) 
                cylinder(r=0.5, h=clamp_segment_h + 30, center=true);
        }
    }
}

// 2. High-Speed Interlocking Wrap-Around Compression Sleeve
module supersonic_retention_clamp() {
    // Left and Right Halves are joined at the front apex and tensioned at the rear
    difference() {
        union() {
            // Main aerodynamic sleeve overlay shell
            color(titanium_dark)
            hull() {
                cylinder(r=leading_edge_r + skin_thickness + 1.2, h=clamp_segment_h, center=true);
                // Extend taper back along the airfoil chord to create mechanical leverage
                translate([airfoil_chord_len * 0.4, 0, 0]) 
                    cylinder(r=skin_thickness, h=clamp_segment_h, center=true);
            }
            
            // Trailing Edge Wedge Tension Blocks (Where clamp sections cinch together)
            color(titanium_dark)
            translate([airfoil_chord_len * 0.4 - 10, 0, 0]) {
                translate([0, 10, 0]) cube([15, 8, clamp_segment_h], center=true);
                translate([0, -10, 0]) cube([15, 8, clamp_segment_h], center=true);
            }
        }

        // Subtract the inner airfoil shape to form a perfectly tight glove over the fin
        hull() {
            cylinder(r=leading_edge_r + 1.2, h=clamp_segment_h + 2, center=true); // Accounts for actuator tape clearance
            translate([airfoil_chord_len, 0, 0]) 
                cylinder(r=1.2, h=clamp_segment_h + 2, center=true);
        }
        
        // Split clearance gap down the middle trailing edge to allow compression tightening
        translate([airfoil_chord_len * 0.25, 0, 0])
            cube([airfoil_chord_len, 4, clamp_segment_h + 5], center=true);
            
        // Counter-sunk tension bolt channels passing through the trailing wedge blocks
        for (z_bolt = [-45, 0, 45]) {
            translate([airfoil_chord_len * 0.4 - 10, 0, z_bolt])
                rotate([90, 0, 0]) {
                    cylinder(d=5.2, h=40, center=true); // Bolt shank path
                    translate([0, 0, 12]) cylinder(d=9, h=10, center=true); // Counter-sunk hex head cavity
                }
        }
    }
}

// 3. Integrated Active Cold Plasma Actuator Ribbon Layer
module embedded_actuator_ribbon() {
    // Fits perfectly into the 1.2mm clearance pocket between the titanium clamp and aircraft skin
    translate([0, 0, 0]) {
        // Dielectric Layer (Kapton Carrier Wrap)
        color(kapton_amber)
        difference() {
            cylinder(r=leading_edge_r + 1.0, h=clamp_segment_h - 10, center=true);
            cylinder(r=leading_edge_r, h=clamp_segment_h, center=true);
        }
        
        // Exposed Supersonic Flight Copper Electrodes
        color(copper_foil) {
            rotate([0, 0, 35]) translate([leading_edge_r + 0.9, 0, 0]) 
                cube([0.2, 4, clamp_segment_h - 20], center=true);
            rotate([0, 0, -35]) translate([leading_edge_r + 0.9, 0, 0]) 
                cube([0.2, 4, clamp_segment_h - 20], center=true);
        }
    }
}

// 4. Captive Tension Hardware Pack
module tension_hardware_fasteners() {
    color(screw_silver) {
        for (z_bolt = [-45, 0, 45]) {
            translate([airfoil_chord_len * 0.4 - 10, -11, z_bolt])
                rotate([90, 0, 0]) {
                    cylinder(d=5, h=22, center=true); // Tension screw shank
                    translate([0, 0, -10]) cylinder(d=8.5, h=4, center=true, $fn=6); // Hex socket bolt head
                }
        }
    }
}

// ========================================================
// RENDER TREE EXECUTION
// ========================================================
union() {
    f14_tail_leading_edge();       // Underlying original F-14 structure
    supersonic_retention_clamp();   // Ti-6Al-4V anti-shear outer frame protective glove
    embedded_actuator_ribbon();    // Active ionized plasma stealth ribbon
    tension_hardware_fasteners();   // Cinching hardware pack
}
