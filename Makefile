tb.exe: *.v
	iverilog -D PERIOD=20 -D CLK_DELAY=0.01 -g2005-sv counter.v tb.v -o tb.exe

counter.vcd: tb.exe
	./tb.exe

debug: counter.vcd
	gtkwave counter.vcd

clean: 
	rm -f tb.exe counter.vcd
