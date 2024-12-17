tb.exe: *.v
	iverilog -D PERIOD=20 -D CLK_DELAY=0.01 -D USE_RAM=1 -D SIMULATION=1 -g2005-sv -f verilog.f -o tb.exe

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

checksta:
	openlane --dockerized initial.json --last-run --from OpenROAD.STApostpnr --to OpenROAD.STApostpnr

postpnrsta:
	openlane --dockerized initial.json --to OpenROAD.STApostpnr

global_pl:
	openlane --dockerized initial.json --to OpenROAD.GlobalPlacementSkipIO

continue:
	openlane --dockerized initial.json --last-run --from OpenROAD.STApostpnr

gds:
	openlane --dockerized initial.json

viewlayout:
	openlane --dockerized initial.json --last-run --flow openinopenroad

clean:
	rm -rf tb.exe counter.vcd
