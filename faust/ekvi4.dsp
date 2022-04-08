// Equalizer with 4 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

num_bells = 4;
process = ek.ekvi(num_bells);
