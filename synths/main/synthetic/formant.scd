(
K.add("formant", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);

	NeoFormant.ar(
		formantfreq: (K_NC.kr("freq", 100) + freqOffset).Klag(lagTime),
		carrierfreq: K_NC.kr("carrierfreq", 250, spec: Spec.specs[\freq]).Klag(lagTime) + freqOffset,
		phaseshift: K_NC.kr("phasehift", 0.5).Klag(lagTime)
	)
	}, numChannelsIn: 1);
)
