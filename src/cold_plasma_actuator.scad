// ==========================================
// SURFACE DIELECTRIC BARRIER DISCHARGE (DBD)
// COLD PLASMA RETROFIT ACTUATOR STRIP SPEC
// ==========================================

$fn = 40;

// --- STRIP COMPONENT DIMENSIONS (mm) ---
strip_length = 200;
strip_width  = 50;

dielectric_thick = 1.0; // Kapton film layer thickness
electrode_thick  = 0.2; // 3oz Copper tape thickness
electrode_width  = 12.0;

// --- COLOR PROFILE ---
kapton_amber   = [0.72, 0.43, 0.12, 0.8]; // Translucent polyimide dielectric
copper_foil    = [0.85, 0.43, 0.24, 1.0]; // Metallic copper electrodes
plasma_cyan    = [0.0, 0.9, 1.0, 0.45];   // Ionized cold electron glow
f14_skin_color = [0.55, 0.58, 0.62, 1.0]; // Ghost Gray airframe surface

// ==========================================
// MODEL ASSEMBLY TREE
// ==========================================

module cold_plasma_assembly() {
    // 1. Baseline Simulation: F-14 Leading Edge Skin Panel Area
    color(f14_skin_color)
        translate([0, 0, -2])
        cube([strip_length + 20, strip_width + 20, 2], center=true);

    // 2. The Dielectric Barrier (Flexible Kapton Tape Film Foundation)
    color(kapton_amber)
        translate([0, 0, dielectric_thick/2])
        cube([strip_length, strip_width, dielectric_thick], center=true);

    // 3. Encapsulated Ground Electrode (Sub-surface copper track)
    color(copper_foil)
        translate([0, -strip_width/4, electrode_thick/2])
        cube([strip_length - 10, electrode_width, electrode_thick], center=true);

    // 4. Exposed Surface Electrode (Offset horizontally from the ground strip)
    color(copper_foil)
        translate([0, strip_width/4, dielectric_thick + electrode_thick/2])
        cube([strip_length - 10, electrode_width, electrode_thick], center=true);

    // 5. RADAR SHIELD VISUALIZATION: Cold Low-Temperature Ionization Glow
    // This is the active, non-thermal electron cloud that absorbs incoming X-band waves [1]
    color(plasma_cyan)
        translate([0, 0, dielectric_thick + 8])
        %cube([strip_length - 5, strip_width - 5, 12], center=true);
}

// Execute complete render node
cold_plasma_assembly();
