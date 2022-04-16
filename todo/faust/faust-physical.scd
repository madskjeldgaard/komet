(

KometSynthFactory.add("karplusstaerk",
	{|dur, damping=0.9, pluckgate=1, freq=440,  gain=0.99, sustained=0|
        var trig = pluckgate;
        var sig = KarplusStaerk.ar(damping:damping, freq:freq, gain:gain, gate:pluckgate, sustain:sustained * pluckgate);

        sig
	}, numChannelsIn: 1
);

// KometSynthFactory.add("klarinet",
// 	{|dur, bellopening(0.5), envattack(1), freq(440), gain(0.6), klarinetgate(1), reedstiffness(0.5), sustained(0), vibratofreq(5), vibratogain(0.25)|
//         Klarinet.ar(bellopening, envattack, freq, gain, klarinetgate, reedstiffness, sustained * klarinetgate, vibratofreq, vibratogain);
//
// 	}, numChannelsIn: 1
// );
//
// KometSynthFactory.add("messing",
// 	{|dur, envattack(1), freq(440), gain(0.5), messinggate(1), lipstension(0.5), mute(0.5), sustained(1), vibratofreq(5), vibratogain(0.5)|
//         Messing.ar(envattack, freq, gain, messinggate, lipstension, mute, sustained * messinggate, vibratofreq, vibratogain);
//
// 	}, numChannelsIn: 1
// );
)
