import("stdfaust.lib");
import("physmodels.lib");

ks_ui = gate : pm.impulseExcitation*gain : pm.ks( (freq : f2l), damping )
with{
    f = hslider("freq",440,20,20000,0.01);
    gain = hslider("gain",0.8,0,1,0.01);
    s = hslider("sustain" ,0,0,1,1);
    damping = hslider("damping" ,0.01,0,1,0.01) : si.smoo;
    t = button("gate");

    gate = t+s : min(1);
    freq = f;
};

process = ks_ui;
