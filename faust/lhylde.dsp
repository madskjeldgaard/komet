// Low shelf filter
import("stdfaust.lib");
import("filters.lib");

low_freq = vslider("freq",8000,10,20000,0.01);
low_level = vslider("level",0,-96,96,0.01);

process = low_shelf(low_level, low_freq);
