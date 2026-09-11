#!/usr/bin/env python3
"""
KiCad Solid-State Peltier Climate H-Bridge Constraint Injector
Enforces heavy power track spacing guidelines for avionics bay temperature regulation
"""

import os

def inject_peltier_power_rules(pcb_filepath):
    """
    Applies dedicated high-current isolation zones around the current-reversal H-Bridge MOSFETs
    to protect sensitive communication and logic buses from thermal control spikes.
    """
    if not os.path.exists(pcb_filepath):
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Climate Core\")\n)")

    print(f"[*] Injecting solid-state Peltier driver power constraints on: {pcb_filepath}")

    # Design rules regulating high-current polarity-reversal tracks
    hbridge_rules = """
  (custom_rules
	(rule "PELTIER_HBRIDGE_HIGH_CURRENT_ISOLATION"
		(constraint clearance (min 5.0mm))
		(condition "A.NetClass == 'TEC_Power_Rails' || B.NetClass == 'TEC_Power_Rails'"))
	(rule "THERMISTOR_LOW_NOISE_GUARD"
		(constraint clearance (min 3.0mm))
		(condition "A.NetClass == 'Temp_Sensors' && B.NetClass == 'Chassis_Ground'"))
  )
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "PELTIER_HBRIDGE_HIGH_CURRENT_ISOLATION" in content:
            print("[!] Warning: Polarity-reversal power rules are already defined on this layout module.")
            return True

        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Formatting anomaly detected inside climate board geometry.")
            return False

        updated_content = content[:insert_marker] + hbridge_rules + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: High-current H-Bridge safety constraints permanently locked into KiCad.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout = "climate_controller.kicad_pcb"
    inject_peltier_power_rules(target_layout)
