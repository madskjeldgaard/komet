(
KometSynthFactory.add("stringvoice",
	{|dur, trigFreq=10, freq=440, accent=0.5, structure=0.5, brightness=0.5, damping=0.1, trigdur=0.001|
		var trig = Trig1.ar(in: 1.0,  dur: trigdur);
        var lagTime = \lagTime.kr(1);
		var sig = StringVoice.ar(
			trig,
			infsustain: trig,
			freq:freq.klag(lagTime),
			accent: accent.klag(lagTime),
			structure: structure.klag(lagTime),
			brightness: brightness.klag(lagTime),
			damping: damping.klag(lagTime),
		);

		sig
	}, numChannelsIn: 1
)
)
