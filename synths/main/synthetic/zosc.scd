(
K.add("zosc", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	ZOsc.ar(
		freq: (KNC.kr("freq", 100) + freqOffset).Klag(lagTime),
		formantfreq: KNC.kr("formantfreq", 91, spec: Spec.specs[\freq]).Klag(lagTime) + freqOffset,
		shape: KNC.kr("shape", 0.5).Klag(lagTime),
		mode: KNC.kr("mode", spec: [-1.0,1.0]).Klag(lagTime)
	)
}, numChannelsIn: 1);
)
