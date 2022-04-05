// Equalizer with 4 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

nuK_bells = 4;
process = ek.ekvi(nuK_bells);
