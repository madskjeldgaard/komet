(
var desc = "Two sinewaves multiplied by and sync'ed to a carrier",
func = {|dur, freq=440, freqOffset=0|

    var lagTime = \lagTime.kr(0.001);

    freq = freq + freqOffset.klag(lagTime);
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

    VosimOsc.ar(
        freq: (freq + freqOffset).klag(lagTime),
        form1freq: K_NC.kr("form1freq", 1054, spec: Spec.specs[\freq]).klag(lagTime),
        form2freq: K_NC.kr("form2freq", 454, spec: Spec.specs[\freq]).klag(lagTime),
        shape: K_NC.kr("shape", 0, spec: [-1.0,1.0]).klag(lagTime)
    )
},
    type = \synth,
    category = \synthetic,
    basename = \vosim,
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
