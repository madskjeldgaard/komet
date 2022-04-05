import("stdfaust.lib");
import("physmodels.lib");

process = brassModel(tubeLength,lipsTension,mute,pressure)
with{
    f = hslider("freq",440,10,20000,0.0001);
    gain = hslider("gain",0.5,0,1,0.01);
    envAttack = hslider("envAttack",1,0,30,0.01)*0.001;
    s = hslider("sustain",0,0,1,1);
    lipsTension = hslider("lipsTension",0.5,0,1,0.01) : si.smoo;
    mute = hslider("mute",0.5,0,1,0.01) : si.smoo;
    vibratoFreq = hslider("vibratoFreq",5,1,100,0.01);
    vibratoGain = hslider("vibratoGain",0.5,0,1,0.01)*0.04;
    t = button("gate");

    gate = t+s : min(1);
    vibrato = 1+os.osc(vibratoFreq)*vibratoGain*envelope;
    freq = f;
    envelope = gate*gain : si.smooth(ba.tau2pole(envAttack));

    tubeLength = freq : f2l;
    pressure = envelope*vibrato;
};
