#!/usr/bin/env python3
"""
KiCad High-Voltage/High-Frequency Design Constraint Injector
Applies explicit clearances for F-14 Cold Ionization Micro-Pulser Board
"""

import os

def apply_hv_clearance_rules(pcb_filepath):
    """
    Applies strict isolation distances to prevent electrical arcing
    across high-frequency high-voltage trace paths.
    """
    if not os.path.exists(pcb_filepath):
        print(f"Error: Target layout board layout path '{pcb_filepath}' not found.")
        return False
        
    print(f"[*] Ingesting KiCad layout architecture profile: {pcb_filepath}")
    
    # Custom custom script custom programmatic net-rules block design layout
    hv_custom_rules = """
(custom_rules
	(rule "HIGH_VOLTAGE_IONIZATION_ISOLATION"
		(constraint clearance (min 6.5mm))
		(condition "A.NetClass == 'HV_Pulse_Output' || B.NetClass == 'HV_Pulse_Output'"))
	(rule "CREEPAGE_TRACK_BARRIER_ISOLATION"
		(constraint clearance (min 8.0mm))
		(condition "A.NetClass == 'HV_Pulse_Output' && B.NetClass == 'GND'"))
	(rule "SIGNAL_CROSS_TALK_GUARD"
		(constraint clearance (min 4.0mm))
		(condition "A.NetClass == 'RF_Clock_Sync' || B.NetClass == 'Analog_Telemetry'"))
)
"""
    
    try:
        with open(pcb_filepath, 'r') as f:
            board_data = f.read()
            
        # Verify if custom design constraints rules structure block already exists
        if "HIGH_VOLTAGE_IONIZATION_ISOLATION" in board_data:
            print("[!] Warning: High Voltage clearance injection script rules already defined on layout profile.")
            return True
            
        # Inject design constraints rules block right before the final closing bracket node element
        insert_index = board_data.rfind(")")
        if insert_index == -1:
            print("[-] Failure: Invalid KiCad file format formatting matrix.")
            return False
            
        updated_board_data = board_data[:insert_index] + hv_custom_rules + "\n)"
        
        with open(pcb_filepath, 'w') as f:
            f.write(updated_board_data)
            
        print("[+] Success: Programmatic 6.5mm/8.0mm clearance constraints successfully injected into KiCad matrix.")
        return True
        
    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

# Execution placeholder target path structure map
if __name__ == "__main__":
    # Point directly to your active working KiCad local project directory configuration
    target_board_file = "f14_cold_plasma_pulser.kicad_pcb"
    
    # Creates a dummy file layout placeholder testing layout target if missing out of the kit box
    if not os.path.exists(target_board_file):
        with open(target_board_file, "w") as dummy_f:
            dummy_f.write("(kicad_pcb (version 20240101) (host pcbnew \"Generated Core Fabric Test Layout\")\n)")
            
    apply_hv_clearance_rules(target_board_file)
