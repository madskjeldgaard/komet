// High shelf filter
import("stdfaust.lib");
import("filters.lib");

high_freq = vslider("freq",8000,10,20000,0.01);
high_level = vslider("level",0,-96,96,0.01);

process = high_shelf(high_level, high_freq);
