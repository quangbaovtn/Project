tb.exe: *.v
	iverilog -D PERIOD=20 -D CLK_DELAY=0.01 -D USE_RAM=1 -g2005-sv -f verilog.f -o tb.exe

counter.vcd: tb.exe
	./tb.exe

debug: counter.vcd
	gtkwave counter.vcd

synthesis:
	openlane --dockerized initial.json --to Yosys.Synthesis

floorplan:
	openlane --dockerized initial.json --to OpenROAD.Floorplan

prepnrsta:
	openlane --dockerized initial.json --to OpenROAD.STAPrePNR

midpnrsta:
	openlane --dockerized initial.json --to OpenROAD.STAMidPNR-3

postpnrsta:
	openlane --dockerized initial.json --to OpenROAD.STApostpnr

GDS:
	openlane --dockerized initial.json

global_pl:
	openlane --dockerized initial.json --to OpenROAD.GlobalPlacementSkipIO

viewlayout:
	openlane --dockerized initial.json --last-run --flow openinopenroad

clean:
	rm -rf tb.exe counter.vcd
