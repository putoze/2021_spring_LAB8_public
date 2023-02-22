###################################################################

# Created by write_sdc on Wed Dec 22 12:18:58 2021

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_load -pin_load 0.05 [get_ports CLOCK_GATED]
set_max_delay 8  -from [list [get_ports CLOCK] [get_ports SLEEP_CTRL] [get_ports RST_N]]  -to [get_ports CLOCK_GATED]
