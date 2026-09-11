#!/usr/bin/env python3
"""
KiCad MIL-STD-1760 Sea Spear Data Bus Injection Routine
Configures high-speed digital weapon tracking traces for target handshakes
"""

import os

def apply_sea_spear_data_rules(pcb_filepath):
    """
    Applies strict matching width constraints on the digital firing lines
    to allow the RIO to pass multi-target tracking strings without signal packet loss.
    """
    if not os.path.exists(pcb_filepath):
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Weapons Bridge\")\n)")

    print(f"[*] Injecting MIL-STD-1760 digital weapon data constraints into: {pcb_filepath}")

    # Digital differential bus track widths optimized for noise protection
    weapons_bus_rules = """
  (custom_rules
	(rule "SEA_SPEAR_1760_BUS_WIDTH_MATCH"
		(constraint clearance (min 0.6mm))
		(constraint track_width (to 0.45mm))
		(condition "A.NetClass == 'Weapons_1760_Bus'"))
	(rule "HIGH_VOLTAGE_IGNITION_SAFE_GAP"
		(constraint clearance (min 5.0mm))
		(condition "A.NetClass == 'Missile_Ignition_Pulse' && B.NetClass == 'Weapons_1760_Bus'"))
  )
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "SEA_SPEAR_1760_BUS_WIDTH_MATCH" in content:
            print("[!] Warning: High-speed weapons data bus rules are already active on this profile.")
            return True

        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Formatting anomaly detected inside weapon board geometry.")
            return False

        updated_content = content[:insert_marker] + weapons_bus_rules + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: MIL-STD-1760 tracking guidelines locked into weapons board directory.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout = "weapons_matrix.kicad_pcb"
    apply_sea_spear_data_rules(target_layout)
