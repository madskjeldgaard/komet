(
KometSynthFactory.add("zosc", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	ZOsc.ar(
		freq: (K_NC.kr("freq", 100) + freqOffset).klag(lagTime),
		formantfreq: K_NC.kr("formantfreq", 91, spec: Spec.specs[\freq]).klag(lagTime) + freqOffset,
		shape: K_NC.kr("shape", 0.5).klag(lagTime),
		mode: K_NC.kr("mode", spec: [-1.0,1.0]).klag(lagTime)
	)
}, numChannelsIn: 1);
)
