// Equalizer with 5 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

nuK_bells = 5;
process = ek.ekvi(nuK_bells);
