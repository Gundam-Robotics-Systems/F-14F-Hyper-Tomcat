To support the U.S. Navy's requirement for the F-14F to float indefinitely on its emergency flotation bags and integrate with **Sea Machines Robotics autonomous marine control software**, the system handles the transition from an airborne jet to a waterborne autonomous vessel.

By leveraging the **Univac-Aegis Network Bridge (Slot 3)** inside our drop-in chassis, the system acts as a translator between modern Sea Machines autonomous steering protocols and the aircraft's mechanical control systems.

When floating, the Sea Machines software treats the F-14F as an autonomous surface vessel (ASV). It commands the **Brushless Digital Fuel Boost Pump** to generate low-level idling water-thrust through the engine nacelles, and utilizes the **flexible wing-glove conduit links** (`plasma_conduit_tracks.scad`) to actuate the variable-sweep wings and tail flippers as hydro-rudders to steer the jet through the water.

Python Sea Machines NMEA Marine Data Bridge (`sea_machines_asv_bridge.py`)

This routing routine runs inside the **Univac-Aegis Command Core (Slot 3)**. It listens for standardized **NMEA-0183 / NMEA-2000 marine autonomy packets** broadcast by the Sea Machines uncrewed helm computer and translates them into physical rudder actuation coordinates across the passive backplane.

Autonomous Waterborne Operational Protocols

-   **Autonomous Hydro-Steering Matrix:** The Sea Machines integration script takes standard marine rudder steering commands and maps them directly to the F-14F's tail stabilizers and flaps. By turning the tail fins into water rudders, the jet can execute tight aquatic pivot maneuvers while floating.
-   **Sealed Fuel Pump Thrust Generation (`sealed_fuel_pump`):** Instead of lighting the massive jet engines in the water, the Sea Machines link triggers the **Brushless Digital Fuel Boost Pump** to run at a lower, sustained idle threshold. This pushes fuel or water through the rear nozzles to create an efficient, uncrewed surface vehicle propulsion stream without drawing heavy current or overheating.
-   **Continuous Flotation Stabilization Loop:** The Python engine continuously monitors the inflation pressure of the emergency buoyancy bags (`simulated_bag_psi`). If wave impacts or saltwater shifts cause the pressure to fall below **14.5 PSI**, the code automatically activates the secondary solenoid lines to keep the F-14F floating stable for infinity.
