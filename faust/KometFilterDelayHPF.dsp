declare name 	"KometFilterDelayHPF";
declare author 	"Yann Orlarey";
declare author 	"Mads Kjeldgaard";
declare copyright "Grame";
declare version "1.0";
declare license "STK-4.3";

import("stdfaust.lib");

process = par(i, 1, voice)
with {
	voice 	= (+ : de.sdelay(N, interp, dtime) : ve.korg35HPF(normFreq,Q) : co.limiter_1176_R4_mono ) ~ *(fback);
	N 		= int(2^19);
	Q = hslider("Q",1,0.5,10,0.01);
	normFreq = hslider("freq",0.5,0,1,0.001):si.smoo;
	interp 	= hslider("interpolation",10,1,100,0.1)*ma.SR/1000.0;
	dtime	= hslider("delay", 0, 0, 5000, 0.1)*ma.SR/1000.0;
	fback 	= hslider("feedback",0,0,100,0.1)/100.0;
};
