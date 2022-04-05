(
K.add("zosc", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	ZOsc.ar(
		freq: (K_NC.kr("freq", 100) + freqOffset).Klag(lagTime),
		formantfreq: K_NC.kr("formantfreq", 91, spec: Spec.specs[\freq]).Klag(lagTime) + freqOffset,
		shape: K_NC.kr("shape", 0.5).Klag(lagTime),
		mode: K_NC.kr("mode", spec: [-1.0,1.0]).Klag(lagTime)
	)
}, numChannelsIn: 1);
)
