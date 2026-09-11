#!/usr/bin/env python3
"""
KiCad Digital ABS / Anti-Skid Sensor Constraint Injector
Enforces high-speed signal tracking clearances for the F-14F brake control sub-module
"""

import os

def apply_antiskid_constraints(pcb_filepath):
    """
    Applies dedicated low-noise isolation paths around the digital anti-skid tracking nodes
    to ensure perfect wheel-speed braking tracking under high deceleration.
    """
    if not os.path.exists(pcb_filepath):
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Brakes Matrix\")\n)")

    print(f"[*] Injecting digital anti-skid sensor bus constraints on: {pcb_filepath}")

    # Explicit isolation guidelines separating digital pulse counter signals from heavy power lines
    antiskid_rules = """
  (custom_rules
	(rule "ANTI_SKID_HIGH_SPEED_PULSE_ISOLATION"
		(constraint clearance (min 3.5mm))
		(condition "A.NetClass == 'Wheel_Speed_Sensors' || B.NetClass == 'Wheel_Speed_Sensors'"))
	(rule "BRAKE_VALVE_SOLENOID_DECOUPLING"
		(constraint clearance (min 4.0mm))
		(condition "A.NetClass == 'Hydraulic_Solenoid_Power' && B.NetClass == 'Logic_Signals'"))
  )
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "ANTI_SKID_HIGH_SPEED_PULSE_ISOLATION" in content:
            print("[!] Warning: Brake logic constraints are already active on this layout profile.")
            return True

        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Structural formatting failure inside brake circuit document.")
            return False

        updated_content = content[:insert_marker] + antiskid_rules + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: High-fidelity anti-skid sensor guidelines safely locked into KiCad.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout = "brake_controller.kicad_pcb"
    apply_antiskid_constraints(target_layout)
