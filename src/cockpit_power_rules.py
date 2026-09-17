#!/usr/bin/env python3
"""
KiCad Cockpit Power Regulation Track & Safety Constraint Injector
Enforces heavy filtering clearances for the 28V DC step-down regulator board
"""

import os

def apply_cockpit_power_constraints(pcb_filepath):
    """
    Applies strict physical track spacing guidelines between raw 28V aircraft power lines
    and secondary regulated 5V data rails to guarantee explosion-proof isolation.
    """
    if not os.path.exists(pcb_filepath):
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Cockpit Power Grid\")\n)")

    print(f"[*] Injecting solid-state power routing safety constraints on: {pcb_filepath}")

    # Design rules creating absolute isolation around incoming airframe power feeds
    power_grid_rules = """
  (custom_rules
	(rule "RAW_28V_BUS_SURGE_ISOLATION"
		(constraint clearance (min 6.0mm))
		(constraint track_width (to 2.5mm))
		(condition "A.NetClass == 'Airframe_28V_Input' || B.NetClass == 'Airframe_28V_Input'"))
	(rule "REGULATED_5V_TELEMETRY_GUARD"
		(constraint clearance (min 3.0mm))
		(constraint track_width (to 0.8mm))
		(condition "A.NetClass == 'Regulated_Outputs' && B.NetClass == 'Chassis_Ground'"))
  )
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "RAW_28V_BUS_SURGE_ISOLATION" in content:
            print("[!] Warning: Cockpit power safety constraints are already active on this directory.")
            return True

        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Structural formatting failure inside power board circuit document.")
            return False

        updated_content = content[:insert_marker] + power_grid_rules + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: High-surge isolation and heavy trace guidelines locked into KiCad.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout = "cockpit_power.kicad_pcb"
    apply_cockpit_power_constraints(target_layout)
