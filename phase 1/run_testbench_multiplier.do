vsim -gui work.tbmachinemultiplier
add wave -position insertpoint  \
sim:/tbmachinemultiplier/s_a_input \
sim:/tbmachinemultiplier/s_b_input \
sim:/tbmachinemultiplier/s_clk \
sim:/tbmachinemultiplier/s_output
run 200 ns