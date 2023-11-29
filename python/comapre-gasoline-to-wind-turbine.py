#!/usr/bin/env python3

# Set the energy content of gasoline (in British Thermal Units per gallon)
gasoline_energy = 124000
# Set the average efficiency of a gasoline engine (in percent)
gasoline_efficiency = 20
# Set the average capacity factor of a wind turbine (in percent)
wind_capacity_factor = 35

# Calculate the average amount of energy produced per gallon of gasoline (in kWh)
# Energy content * engine efficiency * conversion factor from BTU to kWh
gasoline_output_kwh = (gasoline_energy * gasoline_efficiency / 100) * 0.00029307107

# Calculate the average amount of energy produced per kWh of wind energy
# 1 kWh of wind energy * capacity factor
wind_output_kwh = 1 * (wind_capacity_factor / 100)

# Print the result
print(f"One gallon of gasoline produces {gasoline_output_kwh:.3f} kilowatt-hours of energy, "
      f"compared to {wind_output_kwh:.3f} kilowatt-hours of wind energy.")