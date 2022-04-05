(
K.add("formant", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);

	NeoFormant.ar(
		formantfreq: (KNC.kr("freq", 100) + freqOffset).Klag(lagTime),
		carrierfreq: KNC.kr("carrierfreq", 250, spec: Spec.specs[\freq]).Klag(lagTime) + freqOffset,
		phaseshift: KNC.kr("phasehift", 0.5).Klag(lagTime)
	)
	}, numChannelsIn: 1);
)
