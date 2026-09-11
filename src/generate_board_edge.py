#!/usr/bin/env python3
"""
KiCad Asymmetric Board Outline Generator
Programmatically injects the F-14 contoured fuselage edge cut lines into the PCB metadata
"""

import os

def initialize_f14_board_outline(pcb_filepath):
    """
    Applies the custom asymmetric chamfer line matrix onto the KiCad Edge.Cuts layer.
    """
    if not os.path.exists(pcb_filepath):
        # Establish base board header envelope block if file doesn't exist
        with open(pcb_filepath, "w") as f:
            f.write("(kicad_pcb (version 20240101) (host pcbnew \"F-14 Contoured Card\")\n)")

    print(f"[*] Formatting Edge.Cuts dimensional coordinates for: {pcb_filepath}")

    # Explicit geometric polygon nodes mapping out the F-14 corner relief chamfers
    edge_cuts_payload = """
  (gr_line (start -90 -80) (end 55 -80) (layer "Edge.Cuts") (width 0.15) (tstamp 2026-09-10))
  (gr_line (start 55 -80) (end 90 -45) (layer "Edge.Cuts") (width 0.15) (tstamp 2026-09-10))
  (gr_line (start 90 -45) (end 90 80) (layer "Edge.Cuts") (width 0.15) (tstamp 2026-09-10))
  (gr_line (start 90 80) (end -90 80) (layer "Edge.Cuts") (width 0.15) (tstamp 2026-09-10))
  (gr_line (start -90 80) (end -90 -80) (layer "Edge.Cuts") (width 0.15) (tstamp 2026-09-10))
"""

    try:
        with open(pcb_filepath, 'r') as f:
            content = f.read()

        if "Edge.Cuts" in content and "90 -45" in content:
            print("[!] Warning: Contoured F-14 fuselage edge dimensions are already defined on this layout profile.")
            return True

        # Inject outline vector strings before the final closing brace node element wrapper
        insert_marker = content.rfind(")")
        if insert_marker == -1:
            print("[-] Error: Formatting anomaly detected inside target file formatting.")
            return False

        updated_content = content[:insert_marker] + edge_cuts_payload + "\n)"

        with open(pcb_filepath, 'w') as f:
            f.write(updated_content)

        print("[+] Success: Asymmetric F-14 Edge.Cuts profile permanently locked into KiCad infrastructure.")
        return True

    except Exception as e:
        print(f"[-] Processing critical failure: {str(e)}")
        return False

if __name__ == "__main__":
    target_layout_profile = "univac_ix_mainframe_core.kicad_pcb"
    initialize_f14_board_outline(target_layout_profile)
