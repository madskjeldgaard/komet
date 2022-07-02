(
var desc = "A karplus strong based physical model of a string",
    func = {|dur, pluckLevel=0.5,  freq=440,pluckDur=0.1, freqOffset=0, pluckDecay=5, pluckCoef=0.1, pluckMaxDelay=0.015|

        var sig, pitchenvAmount;
        var trig = Trig1.ar(1, pluckDur);
        var lagTime = \lagTime.kr(0.001);
        freq = freqOffset+freq;
        freq = freq.kWithPitchEnv(
            dur,
            K_NC.kr("pitchEnvAmount", 0).klag(lagTime),
            envType:\adsr
        );
        freq = freq.kWithWow(
            K_NC.kr("wow", 0.0),
            wowMinFreq:0.01,
            wowMaxFreq: 10.0
        );

        Pluck.ar(
            in: WhiteNoise.ar(pluckLevel),
            trig: trig,
            maxdelaytime: pluckMaxDelay,
            delaytime: freq.reciprocal,
            decaytime: pluckDecay.klag(lagTime),
            coef: pluckCoef.klag(lagTime)
        );

    },
    type = \synth,
    category = \physical,
    basename = \pluck,
    numChans = 1,
    specs = (
        freq: Spec.specs[\freq],
        //TODO
    );

KometSynthFuncDef(
    basename,
    func,
    type,
    category,
    numChans,
    desc,
    specs,
).add();

)
