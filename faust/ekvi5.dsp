// Equalizer with 5 bells + low and high shelf
import("stdfaust.lib");
import("lib/ekvi.lib");

num_bells = 5;
process = ek.ekvi(num_bells);
