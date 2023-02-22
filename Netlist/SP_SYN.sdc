###################################################################

# Created by write_sdc on Fri Aug 12 12:28:41 2022

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_load -pin_load 0.05 [get_ports out_valid]
set_load -pin_load 0.05 [get_ports {out_data[8]}]
set_load -pin_load 0.05 [get_ports {out_data[7]}]
set_load -pin_load 0.05 [get_ports {out_data[6]}]
set_load -pin_load 0.05 [get_ports {out_data[5]}]
set_load -pin_load 0.05 [get_ports {out_data[4]}]
set_load -pin_load 0.05 [get_ports {out_data[3]}]
set_load -pin_load 0.05 [get_ports {out_data[2]}]
set_load -pin_load 0.05 [get_ports {out_data[1]}]
set_load -pin_load 0.05 [get_ports {out_data[0]}]
create_clock [get_ports clk]  -period 8  -waveform {0 4}
set_max_delay 8  -from [list [get_ports clk] [get_ports rst_n] [get_ports cg_en] [get_ports    \
in_valid] [get_ports {in_data[8]}] [get_ports {in_data[7]}] [get_ports         \
{in_data[6]}] [get_ports {in_data[5]}] [get_ports {in_data[4]}] [get_ports     \
{in_data[3]}] [get_ports {in_data[2]}] [get_ports {in_data[1]}] [get_ports     \
{in_data[0]}] [get_ports {in_mode[2]}] [get_ports {in_mode[1]}] [get_ports     \
{in_mode[0]}]]  -to [list [get_ports out_valid] [get_ports {out_data[8]}] [get_ports          \
{out_data[7]}] [get_ports {out_data[6]}] [get_ports {out_data[5]}] [get_ports  \
{out_data[4]}] [get_ports {out_data[3]}] [get_ports {out_data[2]}] [get_ports  \
{out_data[1]}] [get_ports {out_data[0]}]]
set_false_path   -from [get_clocks clk]  -to [list [get_cells GATED_MUL/latch_or_sleep_reg] [get_cells                 \
GATED_SORT/latch_or_sleep_reg] [get_cells GATED_INV/latch_or_sleep_reg]]
set_input_delay -clock clk  0  [get_ports clk]
set_input_delay -clock clk  0  [get_ports rst_n]
set_input_delay -clock clk  0  [get_ports cg_en]
set_input_delay -clock clk  4  [get_ports in_valid]
set_input_delay -clock clk  4  [get_ports {in_data[8]}]
set_input_delay -clock clk  4  [get_ports {in_data[7]}]
set_input_delay -clock clk  4  [get_ports {in_data[6]}]
set_input_delay -clock clk  4  [get_ports {in_data[5]}]
set_input_delay -clock clk  4  [get_ports {in_data[4]}]
set_input_delay -clock clk  4  [get_ports {in_data[3]}]
set_input_delay -clock clk  4  [get_ports {in_data[2]}]
set_input_delay -clock clk  4  [get_ports {in_data[1]}]
set_input_delay -clock clk  4  [get_ports {in_data[0]}]
set_input_delay -clock clk  4  [get_ports {in_mode[2]}]
set_input_delay -clock clk  4  [get_ports {in_mode[1]}]
set_input_delay -clock clk  4  [get_ports {in_mode[0]}]
set_output_delay -clock clk  4  [get_ports out_valid]
set_output_delay -clock clk  4  [get_ports {out_data[8]}]
set_output_delay -clock clk  4  [get_ports {out_data[7]}]
set_output_delay -clock clk  4  [get_ports {out_data[6]}]
set_output_delay -clock clk  4  [get_ports {out_data[5]}]
set_output_delay -clock clk  4  [get_ports {out_data[4]}]
set_output_delay -clock clk  4  [get_ports {out_data[3]}]
set_output_delay -clock clk  4  [get_ports {out_data[2]}]
set_output_delay -clock clk  4  [get_ports {out_data[1]}]
set_output_delay -clock clk  4  [get_ports {out_data[0]}]
