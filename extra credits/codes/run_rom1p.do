transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

# Compile ROM1PORT
vlog -work work +incdir+C:/Users/supre/Documents/ML\ proj/extra_credits_ML/extra\ credits/codes {C:/Users/supre/Documents/ML proj/extra_credits_ML/extra credits/codes/ROM1PORT.v}

# Load simulation with Altera megafunction library
vsim -L altera_mf_ver work.ROM1PORT
