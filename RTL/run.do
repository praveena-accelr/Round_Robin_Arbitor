if [file exists "work"] {vdel -all}
vlib work

vlog -64 -incr  -sv round_robin_arbitor.sv
vlog -64 -incr  -sv tb_rr_arbitor.sv

vopt -64 +acc=npr tb_rr_arbitor -o testbench_opt

vsim testbench_opt -wlf mywlf.wlf

add log /* -r

run -all