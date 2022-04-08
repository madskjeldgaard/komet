// Linkwitz riley based band splitter
import("stdfaust.lib");

process = fi.crossover3LR4(cf1, cf2) with{
	cf1 = vslider("crossoverFreq1",1500,10,20000,0.001);
	cf2 = vslider("crossoverFreq2",2500,10,20000,0.001);
};
