(
var desc = "A physical model of a guitar string",
    func = {|dur, freq=440, freqOffset=0, pluckgate=1, pluckposition=0.75,  gain=0.99, sustained=0|
		var trig = pluckgate;
		var sig = GuitarStreng.ar(gate: trig, freq:freqOffset+freq, gain: gain,  pluckposition: pluckposition, sustain: sustained*trig);

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
