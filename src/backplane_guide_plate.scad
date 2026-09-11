// ========================================================
// F-14F AVIONICS MODERNIZATION KIT - REAR BACKPLANE DOCK
// MECHANICAL CARD ALIGNMENT GUIDE & CONNECTOR FRAME
// ========================================================

$fn = 50; // High-precision manufacturing circular interpolation

// --- CHASSIS REAR WALL HOUSING SPECIFICATIONS (mm) ---
backplane_width  = 372; // Internal horizontal clearance limit
backplane_height = 240; // Internal vertical clearance ceiling
plate_thickness  = 8.0; // PEEK structural reinforcement panel wall depth

card_slot_spacing = 25.0; // Spacing pitch center-to-center between slots
num_slots         = 4;    // Slots for Univac IX, Hex Logic, Aegis, Weather
socket_w          = 12.0; // Horizontal width of card-edge receiver socket
socket_h          = 110.0;// Vertical clearance height of high-density socket block

// --- COLOR PALETTE ---
peek_black   = [0.15, 0.15, 0.17, 1.0]; // Carbon-filled high-durability polymer frame
fr4_green    = [0.12, 0.44, 0.22, 0.8]; // Multilayer backplane PCB substrate backing
gold_contact = [0.88, 0.73, 0.28, 1.0]; // Gold-plated high-density socket pins
screw_silver = [0.75, 0.78, 0.80, 1.0]; // Chassis perimeter anchoring hardware

// ========================================================
// MECHANICAL MODEL ASSEMBLY
// ========================================================

module backplane_guide_assembly() {
    // 1. Structural FR4 Multilayer Wiring Substrate (The backing PCB)
    color(fr4_green)
        translate([0, 2, 0])
        cube([backplane_width, 2.4, backplane_height], center=true);

    // 2. Heavy-Duty Polymer Alignment Guide Panel Shell
    difference() {
        color(peek_black)
            cube([backplane_width, plate_thickness, backplane_height], center=true);
            
        // Subtract vertical channels for the high-density card-edge socket housings
        for (i = [0 : num_slots - 1]) {
            // Programmatically calculate dynamic X offset for each slot path
            x_offset = -((num_slots - 1) * card_slot_spacing) / 2 + (i * card_slot_spacing);
            
            // Central connector pocket cutout
            translate([x_offset, 0, 0])
                cube([socket_w, plate_thickness + 2, socket_h], center=true);
                
            // --- PLUG-AND-PLAY FEATURE: Beveled Tapered Entry Slits ---
            // Catches incoming card edges and self-aligns them into the socket contacts
            translate([x_offset, -plate_thickness/2 + 2, 0])
                rotate([0, 0, 0])
                hull() {
                    cube([socket_w + 4.0, 0.1, socket_h + 6.0], center=true);
                    translate([0, -3.0, 0]) 
                        cube([socket_w, 0.1, socket_h], center=true);
                }
        }
        
        // Perimeter counter-sunk mounting holes to anchor the frame to the chassis rear wall
        for (x_bolt = [-backplane_width/2 + 15, backplane_width/2 - 15]) {
            for (z_bolt = [-backplane_height/2 + 15, backplane_height/2 - 15]) {
                translate([x_bolt, 0, z_bolt])
                    rotate([90, 0, 0]) {
                        cylinder(d=4.5, h=plate_thickness + 4, center=true); // Screw shank
                        translate([0, 0, -3.5]) cylinder(d=8.0, h=4.0, center=true); // Countersunk head
                    }
            }
        }
    }

    // 3. High-Density Gold Contact Socket Modules (Seated inside the cutouts)
    for (i = [0 : num_slots - 1]) {
        x_offset = -((num_slots - 1) * card_slot_spacing) / 2 + (i * card_slot_spacing);
        translate([x_offset, plate_thickness/2 - 2, 0]) {
            color([0.1, 0.1, 0.1]) cube([socket_w - 0.5, 4.0, socket_h - 2], center=true);
            // Internal gold leaf pin matrix simulation
            color(gold_contact) translate([0, -1, 0]) cube([2.0, 1.0, socket_h - 10], center=true);
        }
    }
}

// Execute active rendering tree module
backplane_guide_assembly();
