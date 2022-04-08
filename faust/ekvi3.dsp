// Equalizer with 3 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

num_bells = 3;
process = ek.ekvi(num_bells);
