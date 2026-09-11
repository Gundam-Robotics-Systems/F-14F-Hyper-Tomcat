Part 2: KiCad Digital Weapon Umbilical Routing Script (`sea_spear_bus_rules.py`)

Because the Brimstone Sea Spear utilizes an advanced **94-GHz millimeter-wave (mmW) active radar seeker** and dual-mode semi-active laser (SAL), it requires a continuous high-speed data stream before launch. The missile must share real-time GPS coordinate loops directly with the cockpit tablet mobile app via our hardware layer. [1, [2](https://mbdainc.com/wp-content/uploads/2023/10/2018-BRIMSTONE-datasheet.pdf), [3](https://missilethreat.csis.org/missile/brimstone/)]

This script processes your weapon network board design file (`weapons_matrix.kicad_pcb`), injecting strict **differential pair track matching** to support the MIL-STD-1760 digital weapons bus architecture with a mandatory **5.0mm noise decoupling safety gap**.
