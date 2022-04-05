(
K.add("stringvoice",
	{|dur, trigFreq=10, freq=440, accent=0.5, structure=0.5, brightness=0.5, damping=0.1, trigdur=0.001|
		var trig = Trig1.ar(in: 1.0,  dur: trigdur);
        var lagTime = \lagTime.kr(1);
		var sig = StringVoice.ar(
			trig,
			infsustain: trig,
			freq:freq.Klag(lagTime),
			accent: accent.Klag(lagTime),
			structure: structure.Klag(lagTime),
			brightness: brightness.Klag(lagTime),
			damping: damping.Klag(lagTime),
		);

		sig
	}, numChannelsIn: 1
)
)
