(
var desc = "Formant oscillator with aliasing-free phase reset",
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

    NeoFormant.ar(
		formantfreq: (freq + freqOffset).klag(lagTime),
		carrierfreq: K_NC.kr("carrierfreq", 250, spec: Spec.specs[\freq]).klag(lagTime) + freqOffset,
		phaseshift: K_NC.kr("phasehift", 0.5).klag(lagTime)
	)
},
    type = \synth,
    category = \synthetic,
    basename = \formant,
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
