vsim -gui work.tbmachineadder
add wave -position insertpoint  \
sim:/tbmachineadder/s_clk \
sim:/tbmachineadder/s_a_input \
sim:/tbmachineadder/s_b_input \
sim:/tbmachineadder/s_output
run 200 ns