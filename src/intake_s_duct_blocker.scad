// ========================================================
// F-14F DROP-IN COMPOSITE ENGINE INTAKE S-DUCT BLOCKER
// NON-DESTRUCTIVE GEOMETRIC RADAR CROSS SECTION REDUCTION
// ========================================================

$fn = 60; // Production fidelity for aerodynamic curvature sweeps

// --- INTAKE TUNNEL GEOMETRIC CONSTANTS (mm) ---
intake_width   = 110;  // Standard internal dimension of F-14 intake trunk
intake_height  = 140;  // Vertical trunk ceiling clearance
duct_length    = 340;  // Insertion depth along the engine path
wall_thick     = 3.5;  // Carbon-fiber/fiberglass radar-absorbent composite skin
s_curve_offset = 45;   // Lateral snake-bend offset distance to break line-of-sight

// --- COLOR PALETTE ---
absorbent_black = [0.12, 0.12, 0.14, 1.0]; // RAM-impregnated composite structural body
vane_silver      = [0.70, 0.73, 0.75, 1.0]; // Low-profile structural guide fins
f14_intake_gray = [0.60, 0.63, 0.65, 0.25]; // Translucent original intake outer wall

// ========================================================
// MECHANICAL MODEL ASSEMBLY
// ========================================================

module engine_intake_s_duct() {
    // 1. Baseline Simulation: Original Straight F-14 Intake Tunnel Outer Space
    color(f14_intake_gray)
        translate([0, 0, duct_length/2])
        %cube([intake_width, intake_height, duct_length], center=true);

    // 2. The Slide-In Geometric S-Duct Sleeve Shell
    // Uses a programmatic lofted snake deformation to hide the rear engine face
    difference() {
        // Outer sleeve body interface block
        color(absorbent_black)
        union() {
            for (z = [0 : 5 : duct_length]) {
                // Non-linear calculation creating an automated S-curve bend parameter
                x_shift = sin((z / duct_length) * 180) * s_curve_offset;
                
                translate([x_shift, 0, z])
                    cube([intake_width - 2, intake_height - 2, 6], center=true);
            }
        }

        // Subtract internal airway core to form hollow airflow conduit
        union() {
            for (z = [-2 : 5 : duct_length + 2]) {
                x_shift = sin((z / duct_length) * 180) * s_curve_offset;
                
                translate([x_shift, 0, z])
                    cube([intake_width - 2 - (wall_thick*2), intake_height - 2 - (wall_thick*2), 6.5], center=true);
            }
        }
    }

    // 3. Aerodynamic Structural Guide Vanes (Directs boundary layer airflow)
    // Prevents engine compressor stall while optimizing radar wave trap scattering
    color(vane_silver) {
        for (x_vane = [-intake_width/3, 0, intake_width/3]) {
            translate([x_vane, 0, duct_length/2]) {
                intersection() {
                    // Fit precisely within the active S-duct internal airway volume
                    union() {
                        for (z = [0 : 5 : duct_length]) {
                            x_shift = sin((z / duct_length) * 180) * s_curve_offset;
                            translate([x_shift, 0, z])
                                cube([intake_width - 4, intake_height - 4, 6], center=true);
                        }
                    }
                    // Thin vertical guide fin plates
                    translate([-x_vane, 0, 0])
                        cube([2.0, intake_height - 10, duct_length - 20], center=true);
                }
            }
        }
    }
}

// Execute core rendering tree
engine_intake_s_duct();
