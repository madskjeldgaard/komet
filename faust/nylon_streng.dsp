import("stdfaust.lib");
import("physmodels.lib");

nylonguit = pm.nylonGuitar(stringLength,pluckPosition,gain,gate)
with{
    f = hslider("freq",440,20,20000,0.001);
    gain = hslider("gain",0.8,0,1,0.01);
    s = hslider("sustain",0,0,1,1);
    pluckPosition = hslider("pluckPosition" ,0.8,0,1,0.01) : si.smoo;
    t = button("gate");
    gate = t+s : min(1);
    freq = f;
    stringLength = freq : f2l;
};

process = nylonguit;
