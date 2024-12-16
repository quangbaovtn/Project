a.out: *.v
	iverilog counter.v tb.v

tb.vcd: a.out
	./a.out

debug: tb.vcd
	gtkwave counter.vcd

clean: *.out *.vcd
	rm -f *.out *.vcd
