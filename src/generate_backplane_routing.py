#!/usr/bin/env python3
"""
KiCad Multi-Slot Passive Backplane Power & Bus Trace Router
Automates low-impedance parallel backbone wiring for the F-14F upgrade housing kit
"""

import os

def build_passive_backplane_bus(pcb_filepath):
    """
    Injects high-current, low-resistance parallel trace segments directly into 
    the KiCad layout matrix to distribute main VCC and GND across backplane sockets.
    """
    if not os.path.exists(pcb_filepath):
        # Create empty template board shell container if missing
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Backplane passive matrix\")\n)")

    print(f"[*] Injecting heavy-gauge master bus copper traces into backplane: {pcb_filepath}")

    # Programmatic trace paths linking Slot 1 through Slot 4 on the internal copper layers
    bus_routing_payload = """
  (segment (start -37.5 25.0) (end -12.5 25.0) (width 1.2) (layer "In1.Cu") (net 1) (tstamp 2026-09-10))
  (segment (start -12.5 25.0) (end 12.5 25.0) (width 1.2) (layer "In1.Cu") (net 1) (tstamp 2026-09-10))
  (segment (start 12.5 25.0) (end 37.5 25.0) (width 1.2) (layer "In1.Cu") (net 1) (tstamp 2026-09-10))
  (segment (start -37.5 -50.0) (end -12.5 -50.0) (width 1.6) (layer "In2.Cu") (net 0) (tstamp 2026-09-10))
  (segment (start -12.5 -50.0) (end 12.5 -50.0) (width 1.6) (layer "In2.Cu") (net 0) (tstamp 2026-09-10))
  (segment (start 12.5 -50.0) (end 37.5 -50.0) (width 1.6) (layer "In2.Cu") (net 0) (tstamp 2026-09-10))
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "In2.Cu" in content and "37.5 -50.0" in content:
            print("[!] Warning: Passive power distribution bus lines already locked into backplane matrix.")
            return True

        # Splice routing data coordinates prior to the final bracket wrap element node
        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Formatting anomaly detected inside target backplane document layout.")
            return False

        updated_content = content[:insert_marker] + bus_routing_payload + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: Low-impedance 1.2mm/1.6mm master bus networks permanently active in KiCad folder.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout_profile = "backplane_matrix.kicad_pcb"
    build_passive_backplane_bus(target_layout_profile)
