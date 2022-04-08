// Equalizer with 3 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

nuK_bells = 3;
process = eKometSynthFactory.ekvi(nuK_bells);
