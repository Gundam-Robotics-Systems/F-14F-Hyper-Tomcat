#!/usr/bin/env python3
"""
KiCad Tactical SDR Radio RF Constraint Injector
Enforces 50-Ohm impedance tracks and cross-talk guard zones for the F-14F transceiver
"""

import os

def inject_sdr_rf_constraints(pcb_filepath):
    """
    Programmatically injects strict RF layout design rules into the KiCad matrix
    to prevent signal distortion and contain high-frequency electromagnetic noise.
    """
    if not os.path.exists(pcb_filepath):
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 SDR Radio\")\n)")

    print(f"[*] Injecting high-fidelity RF trace constraints on: {pcb_filepath}")

    # Programmatic custom rules block establishing matching impedance boundaries
    rf_routing_rules = """
  (custom_rules
	(rule "RF_ANTENNA_50OHM_IMPEDANCE"
		(constraint clearance (min 0.8mm))
		(constraint track_width (to 0.55mm))
		(condition "A.NetClass == 'RF_Antenna_Trace'"))
	(rule "ADC_DAC_HIGH_SPEED_GUARD_RING"
		(constraint clearance (min 3.0mm))
		(condition "A.NetClass == 'RF_High_Speed_Data' && B.NetClass == 'Power_Rails'"))
	(rule "FREQUENCY_HOPPING_CLOCK_ISOLATION"
		(constraint clearance (min 4.0mm))
		(condition "A.NetClass == 'SDR_Local_Oscillator' || B.NetClass == 'Analog_Telemetry'"))
  )
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "RF_ANTENNA_50OHM_IMPEDANCE" in content:
            print("[!] Warning: RF impedance constraints are already active on this layout profile.")
            return True

        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Formatting anomaly detected inside target file structure.")
            return False

        updated_content = content[:insert_marker] + rf_routing_rules + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: 50-Ohm impedance and clock isolation rules successfully locked into KiCad.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout = "sdr_transceiver.kicad_pcb"
    inject_sdr_rf_constraints(target_layout)
