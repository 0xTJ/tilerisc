###############################################################################
# Created by write_sdc
# Fri Nov 10 14:33:33 2023
###############################################################################
current_design risc16
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 24.0000 
set_clock_uncertainty 0.2500 clk
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {dmem_we}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[15]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[14]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[13]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[12]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[11]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[10]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[9]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[8]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[7]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[6]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[5]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[4]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[3]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[2]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[1]}]
set_load -pin_load 0.1900 [get_ports {dmem_addr[0]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[15]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[14]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[13]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[12]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[11]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[10]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[9]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[8]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[7]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[6]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[5]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[4]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[3]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[2]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[1]}]
set_load -pin_load 0.1900 [get_ports {dmem_data_in[0]}]
set_load -pin_load 0.1900 [get_ports {pc[15]}]
set_load -pin_load 0.1900 [get_ports {pc[14]}]
set_load -pin_load 0.1900 [get_ports {pc[13]}]
set_load -pin_load 0.1900 [get_ports {pc[12]}]
set_load -pin_load 0.1900 [get_ports {pc[11]}]
set_load -pin_load 0.1900 [get_ports {pc[10]}]
set_load -pin_load 0.1900 [get_ports {pc[9]}]
set_load -pin_load 0.1900 [get_ports {pc[8]}]
set_load -pin_load 0.1900 [get_ports {pc[7]}]
set_load -pin_load 0.1900 [get_ports {pc[6]}]
set_load -pin_load 0.1900 [get_ports {pc[5]}]
set_load -pin_load 0.1900 [get_ports {pc[4]}]
set_load -pin_load 0.1900 [get_ports {pc[3]}]
set_load -pin_load 0.1900 [get_ports {pc[2]}]
set_load -pin_load 0.1900 [get_ports {pc[1]}]
set_load -pin_load 0.1900 [get_ports {pc[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 4.0000 [current_design]
