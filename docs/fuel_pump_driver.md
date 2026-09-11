KiCad Brushless Fuel Pump Driver Circuit Schematic (`fuel_pump_driver.py`)

To power the sensorless brushless fuel pump without burning out active electronics during rapid power bus spikes or catapult launches, the motor driver requires an **isolated three-phase MOSFET inverter circuit**.

This automated script layout injector processes your peripheral board file (`peripheral_upgrades.kicad_pcb`), instantly setting down an isolated copper island for the motor drive tracking nodes with an explicit **4.5mm power clearance zone fence** to trap line spikes.
