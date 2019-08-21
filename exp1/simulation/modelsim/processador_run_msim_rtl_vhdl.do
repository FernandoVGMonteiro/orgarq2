transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/dualregfile.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/signExtend.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/shiftleft2.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/rom.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/reg.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/ram.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/mux2to1.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/alu.vhd}
vcom -93 -work work {C:/Users/MateusVendramini/projects/orgarq2/exp1/src/fluxo_de_dados.vhd}

