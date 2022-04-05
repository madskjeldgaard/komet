declare name "Plat";
declare author "Mads Kjeldgaard";
declare copyright "Mads Kjeldgaard";
declare version "1.00";
declare license "GPL";

import("stdfaust.lib");
import("lib/mkdelay.dsp");

// Static
order = 4;
numDelays = 8;
maxdelay = 0.1 * ma.SR;

// Controls
delay = vslider("delaytime",0.1,0.001,2.0,0.01) : *(ma.SR) : si.smoo;
fb = vslider("fb",0.1,0.001,2.0,0.01);
lpf = vslider("cutoff",3500,20.0,20000.0,1);
delayOffset=vslider("delayoffset",0.5,0.0,1.0,0.00001) : si.smoo;
modFreq=vslider("modFreq",0.05,0.0,1.0,0.00001) : si.smoo;
modDepth=vslider("modDepth",0.05,0.0,1.0,0.00001) : si.smoo;
// apFb = vslider("apFb",0.25,0.0,1.0,0.00001) : si.smoo;

// Process
process = _
	<: mkd.parallel_comb_lpf(numDelays, order, maxdelay, delay, delayOffset, fb, lpf)
	:> fi.allpass_fcomb(maxdelay,apdelay(modFreq, modDepth),fb) with{
		apdelay(modFreq, modDepth) = os.lf_triangle(modFreq) + 1.0 : /(2.0)
			: *(maxdelay)
			: *(modDepth);
	};
