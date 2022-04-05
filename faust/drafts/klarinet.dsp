import("stdfaust.lib");
import("physmodels.lib");

process = clarinetModel(tubeLength,blow,reedStiffness,bellOpening)
with{
    f = hslider("freq",440,10,20000,0.00001);
    gain = hslider("gain",0.6,0,1,0.01);
    envAttack = hslider("envAttack",1,0,30,0.01)*0.001;
    s = hslider("sustain",0,0,1,1);
    reedStiffness = hslider("reedStiffness",0.5,0,1,0.01);
    bellOpening = hslider("bellOpening",0.5,0,1,0.01);
    vibratoFreq = hslider("vibratoFreq",5,0.0001,1000,0.0001);
    vibratoGain = hslider("vibratoGain",0.25,0,1,0.01)*0.01;
    t = button("gate");

    gate = t+s : min(1);
    vibrato = 1+os.osc(vibratoFreq)*vibratoGain*envelope;
    freq = f*vibrato;
    envelope = gate*gain : si.smooth(ba.tau2pole(envAttack));

    tubeLength = freq : f2l;
    pressure = envelope; // TODO: double vibrato here!!
    blow = blower(pressure,0.05,2000,vibratoFreq,vibratoGain);
};
