(
K.add("nylonstreng",
	{|dur, freq=440, pluckgate=1, pluckposition=0.75,  gain=0.99, sustained=0|
		var trig = pluckgate;
		var sig = NylonStreng.ar(gate: trig, freq: freq, gain: gain,  pluckposition: pluckposition, sustain: sustained*trig);

        sig
	}, numChannelsIn: 1
);

K.add("guitarstreng",
	{|dur, freq=440, pluckgate=1, pluckposition=0.75,  gain=0.99, sustained=0|
        var trig = pluckgate;
		var sig = GuitarStreng.ar(gate: trig, freq: freq, gain: gain,  pluckposition: pluckposition, sustain: sustained * trig);

        sig
	}, numChannelsIn: 1
);

K.add("elektriskstreng",
	{|dur, freq=440, pluckgate=1, pluckposition=0.75,  gain=0.99, sustained=0|
        var trig = pluckgate;
		var sig = ElektriskStreng.ar(gate: trig, freq: freq, gain: gain,  pluckposition: pluckposition, sustain: sustained*trig);

        sig
	}, numChannelsIn: 1
);

K.add("modularstreng",
	{|dur, pluckgate=1, freq=440, pluckposition=0.75,  gain=0.99, sustained=0, tap=0, scale=0, shape=0|
        var trig = pluckgate;
		var sig = ModularStreng.ar(gate: trig, freq: freq, gain: gain,  pluckposition: pluckposition, scale: scale, shape: shape, tapgate: tap*trig, sustain: sustained*trig);

        sig
	}, numChannelsIn: 1
);

K.add("karplusstaerk",
	{|dur, damping=0.9, pluckgate=1, freq=440,  gain=0.99, sustained=0|
        var trig = pluckgate;
        var sig = KarplusStaerk.ar(damping:damping, freq:freq, gain:gain, gate:pluckgate, sustain:sustained * pluckgate);

        sig
	}, numChannelsIn: 1
);

K.add("floejte",
	{|dur, envattack=1, freq=440, gain=0.9, flutegate=1, mouthposition=0.5, sustained=0, vibratofreq=5, vibratogain=0.5|
        Floejte.ar(envattack, freq, gain, flutegate, mouthposition,  flutegate * sustained, vibratofreq, vibratogain);

	}, numChannelsIn: 1
);

// K.add("klarinet",
// 	{|dur, bellopening(0.5), envattack(1), freq(440), gain(0.6), klarinetgate(1), reedstiffness(0.5), sustained(0), vibratofreq(5), vibratogain(0.25)|
//         Klarinet.ar(bellopening, envattack, freq, gain, klarinetgate, reedstiffness, sustained * klarinetgate, vibratofreq, vibratogain);
//
// 	}, numChannelsIn: 1
// );
//
// K.add("messing",
// 	{|dur, envattack(1), freq(440), gain(0.5), messinggate(1), lipstension(0.5), mute(0.5), sustained(1), vibratofreq(5), vibratogain(0.5)|
//         Messing.ar(envattack, freq, gain, messinggate, lipstension, mute, sustained * messinggate, vibratofreq, vibratogain);
//
// 	}, numChannelsIn: 1
// );
)
