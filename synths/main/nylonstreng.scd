(
var desc = "A physical model of a nylon string",
    func = {|dur, freq=440, freqOffset=0, pluckgate=1, pluckposition=0.75,  gain=0.99, sustained=0|
        var sig, pitchenvAmount;
		var trig = pluckgate;
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
		sig = NylonStreng.ar(gate: trig, freq: freq, gain: gain,  pluckposition: pluckposition, sustain: sustained*trig);

        sig
	},
    type = \synth,
    category = \physical,
    basename = \nylonstreng,
    numChans = 1,
    specs = (
        freq: Spec.specs[\freq],
        pluckgate: [0,1],
        pluckposition: [0.0,1.0],
        gain: [0.0,1.0],
        sustained: [0,1]
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
