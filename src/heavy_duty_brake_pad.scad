// ========================================================
// F-14F RETROFIT KIT - HIGH-RELIABILITY WHEEL BRAKES
// VENTILATED CARBON-SILICON CARBIDE (C-SiC) BRAKE PAD SPEC
// ========================================================

$fn = 60; // Manufacturing-grade circular smoothing

// --- BRAKE PAD GEOMETRIC PROFILE (mm) ---
pad_radius   = 95.0;  // Radius matching the F-14 main gear wheel hub assembly
pad_width    = 42.0;  
pad_thick    = 16.0;  // Thickened material depth to maximize thermal mass capacity
vent_slot_w  = 4.0;   // Heat dissipation ventilation slots

// --- COLOR PALETTE ---
carbon_charcoal = [0.18, 0.18, 0.20, 1.0]; // High-friction carbon matrix composite
heat_shield     = [0.65, 0.65, 0.68, 1.0]; // Titanium thermal isolation backing plate
gold_retaining  = [0.85, 0.65, 0.15, 1.0]; // Heavy-duty wear indicator pins

// ========================================================
// MECHANICAL COMPONENT GENERATION
// ========================================================

module high_g_brake_pad() {
    difference() {
        union() {
            // 1. Titanium Thermal Backing Isolation Plate (Protects hydraulic pistons from heat)
            color(heat_shield)
                cylinder(r=pad_radius, h=4.0, center=true);
            
            // 2. Thick Active Carbon-Silicon Carbide Brake Friction Block
            color(carbon_charcoal)
                translate([0, 0, 4.0 + pad_thick/2])
                cylinder(r=pad_radius - 2.0, h=pad_thick, center=true);
        }
        
        // --- THERMAL FIX: Radial Ventilation Cooling Slots ---
        // Programmatically cuts path channels across face to vent gas and prevent thermal melt
        for (angle = [0 : 30 : 360]) {
            rotate([0, 0, angle])
                translate([pad_radius/2, 0, pad_thick])
                cube([pad_radius, vent_slot_w, pad_thick * 1.5], center=true);
        }
        
        // Center cutout axle hub clearance channel pass-through
        cylinder(d=65, h=pad_thick * 3, center=true);
        
        // Counter-sunk alignment mounting bolt holes to lock to legacy calipers
        for (a_bolt = [15 : 60 : 360]) {
            rotate([0, 0, a_bolt]) translate([pad_radius - 18, 0, 0])
                rotate() {
                    cylinder(d=6.5, h=pad_thick * 3, center=true); // Bolt shank
                    translate([0, 0, 4]) cylinder(d=11.0, h=10.0, center=true); // Counter-sink
                }
        }
    }
}

// Execute active rendering tree module
high_g_brake_pad();
