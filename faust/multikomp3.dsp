// Multiband compressor
import("stdfaust.lib");

numBands = 3;
cf1 = vslider("crossoverFreq0",500,10,20000,0.01);
cf2 = vslider("crossoverFreq1",2500,10,20000,0.01);

process = _ : fi.crossover3LR4(cf1, cf2) : par(bandNum,numBands,bandcomp(bandNum)) :> _
with{
	bandcomp(bandNum, sig) = makeupGain(bandNum) * co.compressor_mono(
			ratio(bandNum),
			thresh(bandNum),
			att(bandNum),
			rel(bandNum),
			sig
			// knee(bandNum),
			// prePost(bandNum),
			// abs(_)
		);

	// TODO
	// According to: https://www.thomann.de/se/onlineexpert_page_mastering_dynamic_processing_the_compressor_and_other_tools.html
	autoGC = thresh(bandNum) - (thresh(bandNum) / ratio(bandNum)) : ba.db2linear : si.smoo;
	makeupGain(bandNum) = vslider("makeupGain%bandNum", 0, -96, 96, 0.1) : si.smoo : ba.db2linear;
	ratio(bandNum) = vslider("ratio%bandNum",4,1,40,0.000001);
	thresh(bandNum) = vslider("thresh%bandNum",-20,-128,0,0.0001);
	att(bandNum) = vslider("attack%bandNum",0.001,0,10,0.0001);
	rel(bandNum) = vslider("release%bandNum",0.01,0,10,0.0001);
	// knee(bandNum) = vslider("knee%bandNum",6,0,100,0.001);
	// prePost(bandNum) = vslider("prePost%bandNum",0,0,2,1); // FIXME: Not sure about this
};
