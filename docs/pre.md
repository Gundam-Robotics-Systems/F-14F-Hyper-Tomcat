## PRE-FLIGHT SYSTEM MANUAL & RECOVERY FIELD PROCEDURES
SUB-SYSTEM TEST: 10 KV SURFACE DIELECTRIC BARRIER DISCHARGE (DBD) COLD IONIZATION ARRAY
PLATFORM SPECIFICATION: F-14F TOMCAT LO-UPGRADE MATRIX
------------------------------
## COMPONENT 3: PRE-FLIGHT ELECTROMAGNETIC FIELD TEST## TECHNICAL INSPECTION PROCEDURE (FLIGHT LINE COMPLIANCE)## 3.1 Safety Requirements & Personnel Manifest

* Hazard Envelope: High-Voltage AC Output (10.5 kV RMS @ 12.5 kHz).
* Personnel Minimum: Two (2) qualified Avionics Technicians (Tech-1 inside cockpit console; Tech-2 ground observer).
* Required Safety Gear: Standard flight-line rubber dielectric insulating boots, Type II anti-static safety glasses.
* Standard Diagnostic Support Tooling Pack (Kit Box 5):
* (1) Handheld Neon Gas Discharge Sensing Wand (Contactless field indicator).
   * (1) Portable Radio Frequency (RF) Snipping Receiver or Spectrum Sniffer Probe.
   * (1) Standard digital insulation-resistance tester (Megohmmeter).

------------------------------
## 3.2 Phase-by-Phase Pre-Flight Checkout Loop

[SAFETY CLEARANCE] ──► [POWER ACTIVATION] ──► [VISUAL SENSING] ──► [RF FIELD SNIFF]
Clear 6-foot loop      Tech-1 turns toggle    Sensing Wand glows   Verify 12.5 kHz
around active fins.    in cockpit console.    bright purple/cyan.  signal emission.

## Phase A: Cold Static Insulation Isolation Check

   1. Aircraft Safe-to-Board State: Verify the aircraft engine lines are fully shut down and ground power is safely connected. Ensure the master avionics master switch is set to the OFF position.
   2. Dielectric Isolation Probe: Connect the digital megohmmeter between the primary high-voltage core feed on the articulating wing bridge (complete_wing_bridge) and the adjacent aluminum fuselage skin ground point.
   3. Resistance Benchmark: Inject a test voltage block. Verify that the system resistance reads greater than 500 Megaohms.
   * If reading is lower: Immediately check the flexible conduit track links for moisture collection, salt spray contamination, or physical cable jacket erosion. Clean with solvent or replace before continuing.
   
## Phase B: Dynamic Hot Plasma Activation & Envelope Verification

   1. Flight Line Safety Perimeter: Tech-2 enforces a strict 6-foot physical clearance radius around the aircraft's vertical stabilizers, engine intake lips, and wing gloves. Ensure no ground crew members are touching any skin panel surfaces.
   2. Cockpit Command Injection: Tech-1 boards the cockpit. Because cockpit displays run the legacy F-14 system software emulations, the active cold ionization system is mapped directly to the original AN/AWG-9 Master Radar Test Toggle Panel Subsystem.
   3. Power Grid Loop Ingestion: Tech-1 flips the Master Test Toggle to ON. This signals the drop-in Univac IX mainframe box to activate the high-frequency micro-pulser driver board (pulser_ground_grid.py).

## Phase C: Non-Thermal Ionization Performance Verification

                      [ Leading Edge Titanium Clamp ]
                                    │
                                    ▼
       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ◄── Active Actinide Glow
      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  ◄── Cold Plasma Surface Ionization
     =======================================================
          ▲
          │
     [========] ◄── Neon Gas Sensing Wand (Held 2 inches away)
          │
          └───► [RESULT]: Strong, continuous Violet/Cyan Discharge (Pass)


   1. Contactless Visual Sensing Gland: Tech-2 approaches the vertical tail fin leading edge holding the handheld Neon Gas Discharge Sensing Wand roughly 2 to 3 inches away from the titanium compression sleeve (supersonic_retention_clamp).
   2. Ionization Response Verification: Move the wand slowly down the length of the leading edge profile. The gas inside the wand must ignite into a strong, continuous violet/cyan glow, confirming that the 10 kV electrostatic field is successfully ionizing the local boundary layer air molecules into a dense electron cloud.
   3. Thermal Cross-Check: Verify visually that the underlying aircraft panel paint layer shows no localized bubbling, smoke, or physical distortion. Touch the tail clamp base using an insulated thermal gun to confirm that the surface remains at ambient environmental temperature (No Thermal Heat Signature Introduced).
   4. Radio Frequency (RF) Sniff Test: Tech-2 points the portable RF Sniffer Probe toward the wing-glove flexible joint conduit track. Tune the receiver tracking loop to the master center frequency (12.5 kHz).
   5. EMI Suppressor Check: Verify a sharp signal surge on the test meter at the target frequency, with zero harmonic side-lobe noise creeping into the aircraft’s UHF/VHF communications channels. This ensures that our inner layer shielding mesh (HV_Shield_GND) is successfully trapping electrical noise away from the cockpit radios.
   6. System De-activation: Tech-1 returns the Master Radar Test Toggle to the OFF position. Tech-2 verifies that the Neon Wand discharge instantly extinguishes and the local electronic field reads absolute zero. The aircraft is officially cleared for stealth penetrations.

------------------------------
## Pre-Flight Mission Readiness Sign-Off Log

| Inspection Milestone | Nominal Metric Range | Real-Time Field Value | Condition Code (Pass/Fail) |
|---|---|---|---|
| Static Ground Isolation | > 500 MΩ @ test injection | __________ MΩ | [ ] PASS / [ ] FAIL |
| Plasma Boundary Ignite | Continuous Neon Wand Glow | [ ] Yes / [ ] No | [ ] PASS / [ ] FAIL |
| Infrared Temperature | Ambient Temp (+/- 2°C) | __________ °C | [ ] PASS / [ ] FAIL |
| EMI Cockpit Isolation | Zero noise on pilot headsets | [ ] Clear / [ ] Hiss | [ ] PASS / [ ] FAIL |

------------------------------

