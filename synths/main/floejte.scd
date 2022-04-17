(
var desc = "A physical model of a flute",
    func = {|dur,
        envattack=1,
        freq=440,
        freqOffset=0,
        gain=0.9,
        flutegate=1,
        mouthposition=0.5,
        sustained=0,
        vibratofreq=5,
        vibratogain=0.5|
        var sig;
        var lagTime = \lagTime.kr(1);
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
        Floejte.ar(
            envattack,
            freq,
            gain,
            flutegate,
            mouthposition,
            flutegate * sustained,
            vibratofreq,
            vibratogain
        );
    },
    type = \synth,
    category = \physical,
    basename = \floejte,
    numChans = 1,
    specs = (
        envattack: [0,10],
        freq: Spec.specs[\freq],
        gain:[0.0,1.0],
        flutegate:[0,1],
        mouthposition:[0.0,1.0],
        sustained:[0,1],
        vibratofreq: Spec.specs.at(\lfofreq),
        vibratogain: [0.0,1.0]
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
