// Linkwitz riley based band splitter
import("stdfaust.lib");

process = fi.crossover2LR4(cf) with{
	cf = vslider("crossoverFreq",1500,10,20000,0.001);
};
