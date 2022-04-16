import("stdfaust.lib");
import("physmodels.lib");

process = fluteModel(tubeLength,mouthPosition,blow)
with{
    f = hslider("freq",440,10,20000,0.00001);
    gain = hslider("gain",0.9,0,1,0.01);
    envAttack = hslider("envAttack",1,0,10,0.01)*0.001;
    s = hslider("sustain",0,0,1,1);
    mouthPosition = hslider("mouthPosition",0.5,0,1,0.0001) : si.smoo;
    vibratoFreq = hslider("vibratofreq",5,0.0001,1000,0.0001);
    vibratoGain = hslider("vibratogain",0.5,0,1,0.0001)*0.04;
    t = button("gate");

    gate = t+s : min(1);
    freq = f;
    envelope = gate*gain : si.smooth(ba.tau2pole(envAttack));

    tubeLength = freq : f2l;
    pressure = envelope;
    blow = blower(pressure,0.05,2000,vibratoFreq,vibratoGain);
};
