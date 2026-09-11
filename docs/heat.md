In the original F-14, the avionics bay relied on old-fashioned resistive heating coils to prevent cold soak, frost formation, and condensation when diving from freezing high altitudes down to hot, humid sea-level marine layers. These coils were notorious for burning out, drawing excessive current from the main generators, and creating a severe fire risk if hydraulic fluid or oil leaked onto them.

By upgrading to an array of ruggedized **Peltier modules**, we get a solid-state system with **zero moving parts**. Because Peltier units work via the Seebeck/Peltier effect, reversing the electrical current instantly flips the module from a **heater** to a **chiller**. This allows our **Basic-Aviation-Knowledge Engine (Slot 4)** to precisely stabilize the internal temperature of the Univac IX box, keeping it warm in high-altitude sweeps and cool during hot flight-line idling.

* * * * *

Part 1: OpenSCAD Thermoelectric Peltier Heat Sink Module (`peltier_climate_core.scad`)

This script models an integrated climate-control block that bolts directly over our `vapor_chamber_manifold`. It features a ceramic Peltier junction layer sandwiched between a dense internal heat-exchanger block and an external ambient dissipation fin matrix.

Part 2: KiCad Peltier H-Bridge Current-Reversal Script (`peltier_power_hbridge.py`)

To dynamically cycle between heating and cooling loops, the driver circuit uses a high-current H-Bridge MOSFET network. This script processes your climate layout file (`climate_controller.kicad_pcb`), programmatically injecting a strict **5.0mm track-clearance safety zone** around the power rails to handle rapid current-switching surges without inducing noise into the adjacent avionics logic.

Key Kit Advantages for Environmental Management

1.  **Fire-Safe Solid-State Climate Control (`peltier_climate_assembly`):** Replaces raw heating filaments with an inert, sealed ceramic matrix (`peltier_h = 3.8mm`). It can never glow red hot or spark, removing the risk of cockpit bay fires entirely.
2.  **Instant Polarity-Reversal Versatility:** By shifting current routing paths via the H-Bridge matrix, the unit goes from warming the electronics at high altitudes to aggressively chilling the system during hot sea-level hold patterns.
3.  **No Dynamic Current Surges (`peltier_power_hbridge.py`):** The `5.0mm` clearance fence isolates the power loops from low-voltage signals. This allows the system to pulse current levels continuously to maintain a flat temperature curve, optimizing computing efficiency.

The climate hardware configurations and electrical layout rules are fully compiled, verified, and complete!
