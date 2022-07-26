declare name "Early_Reflections";
declare author "Alik Rustamoff";

import("stdfaust.lib");

nRefl = 5;
scaleDelays =   hslider("ScaleDelays",1,0,3,0.001);
//scaleWidth =  cc( hslider("[0]Scale Width",1,0,3,0.001));
//biasPans =  cc( hslider("[0] Bias Pans",1,0,3,0.001));

reflector(N) = par(i,N, de.delay(100000, dt(i))): par(i,N, fi.resonbp(fc(i),Q(i),level(i))) : par(i, N, sp.panner(g(i)) )
with {

        //a = j+1; // just so that band numbers don't start at 0
      	level(j) = hslider("Level%j",0,-1,1,0.01) : si.smoo;
        fc(j) = hslider("Freq%j",2000, 20, 20000, 0.01) : si.smoo;
        Q(j) = hslider("Q%j",1,0.01,10,0.01) : si.smoo;
        dt(j) = hslider("Delay%j",20, 20,150,1) * 44.1 * scaleDelays : si.smoo;
        g(j) = hslider("Pan%j",0.5, 0,1,0.001) : si.smoo;

};

process(x,y) = x+y : fi.highpass(1,hpf) : fi.lowpass(1,lpf) <: reflector(nRefl) :> (_ * dw) + (x * (1-dw)), (_ * dw) + (y * (1-dw)):_*gain,_*gain
with{
	lpf = hslider("Lpf", 5000, 50, 20000, 1) : si.smoo;
	hpf = hslider("Hpf", 50, 50, 1600, 1) : si.smoo;
	dw =  vslider("drywet",0.5, 0,1,0.001) ;
	gain = hslider("Output Gain",0,-20,20,0.01) : ba.db2linear;

};
