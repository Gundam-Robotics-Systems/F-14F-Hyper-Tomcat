// ========================================================
// F-14F COCKPIT MOBILE ELECTRONICS RETENTION MOUNT
// HIGH-G ANTI-VIBRATION RAIL CLAMP ASSEMBLY
// ========================================================

$fn = 50; // High-precision mechanical render smoothness

// --- PHYSICAL COCKPIT PROFILE DIMENSIONS (mm) ---
canopy_rail_w  = 25.0; // Dimension of original F-14 interior canopy frame
phone_width    = 82.0; // Accommodation for ruggedized military phone/tablet
phone_height   = 160.0;
clamp_thick    = 4.5;  // 6061-T6 Aluminum structural bracket depth

// --- COLOR PALETTE ---
matte_black    = [0.15, 0.15, 0.16, 1.0]; // Non-reflective anodized military finish
rubber_pad     = [0.30, 0.30, 0.32, 1.0]; // Shock-absorbing silicone vibration isolation
screw_silver   = [0.82, 0.84, 0.86, 1.0]; // High-tensile clamping thumb-fasteners
phone_glass    = [0.0, 0.60, 0.85, 0.45]; // Simulation screen face

// ========================================================
// MECHANICAL COMPONENT GENERATION
// ========================================================

module cockpit_hardware_mount() {
    // A. THE AIRFRAME RAIL CLAMP BASE (Clips onto canopy framework)
    color(matte_black)
    difference() {
        // Main block enclosing the frame profile
        cube([canopy_rail_w + (clamp_thick*2), 35, canopy_rail_w + (clamp_thick*2)], center=true);
        // Interior slot matching the airframe rail width
        cube([canopy_rail_w, 40, canopy_rail_w], center=true);
        // Threaded clamping bolt channel hole
        translate([canopy_rail_w/2 + clamp_thick, 0, 0])
            rotate([0, 90, 0]) cylinder(d=5.2, h=20, center=true);
    }
    
    // Clamping Tension Thumb-Screw Hardware
    color(screw_silver)
        translate([canopy_rail_w/2 + clamp_thick + 4, 0, 0])
        rotate([0, 90, 0]) {
            cylinder(d=5, h=16, center=true);
            translate([0, 0, 8]) cylinder(d=16, h=5, center=true); // Oversized adjustment head
        }

    // B. THE HIGH-G PHONE RETENTION CRADLE (Rotates on central pivot ball)
    translate([0, 0, canopy_rail_w/2 + 35]) {
        // Rear Support Backplate
        color(matte_black) cube([phone_width + 8, 12, phone_height * 0.6], center=true);
        
        // Anti-Vibration Heavy Rubber Liners
        color(rubber_pad) translate([0, -4, 0]) cube([phone_width, 4, phone_height * 0.58], center=true);
        
        // --- ANTI-SHEAR PROFILE: Side Clamping Jaw Retention Lips ---
        color(matte_black) {
            // Left grip wall
            translate([-phone_width/2 - 3, 4, 0]) cube([6, 20, phone_height * 0.6], center=true);
            // Right grip wall
            translate([phone_width/2 + 3, 4, 0]) cube([6, 20, phone_height * 0.6], center=true);
            // Bottom retention shelf to arrest downward vertical G-drop displacement
            translate([0, 4, -phone_height * 0.3]) cube([phone_width + 8, 20, 6], center=true);
        }
        
        // Reference Layout: Mockup visualization of the seated navigation phone
        color(phone_glass) translate([0, 4, 0]) cube([phone_width, 10, phone_height], center=true);
    }
}

// Execute active rendering architecture module
cockpit_hardware_mount();
