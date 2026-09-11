KiCad Safe-State telemetry Logic Script (`seat_telemetry_isolation.py`)

This automated script processes your layout data (`seat_sensor_hub.kicad_pcb`), injecting an explicit **5.5mm isolation clearance barrier track rule** around the seat monitoring loop pins. This ensures that static charges or heavy currents from cockpit displays never jump into the telemetry lines and trigger false sensor flags.
