// Linkwitz riley based band splitter
import("stdfaust.lib");

process = fi.crossover4LR4(cf1, cf2, cf3) with{
	cf1 = vslider("crossoverFreq1",1500,10,20000,0.001);
	cf2 = vslider("crossoverFreq2",2500,10,20000,0.001);
	cf3 = vslider("crossoverFreq3",5500,10,20000,0.001);
};
