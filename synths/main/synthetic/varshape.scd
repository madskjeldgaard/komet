(
K.add("varshape", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	VarShapeOsc.ar(
		freq: (KNC.kr("freq", 100) + freqOffset).Klag(lagTime),
		pw: KNC.kr("pw", 0.5).Klag(lagTime),
		waveshape: KNC.kr("shape", 0.5).Klag(lagTime),
		sync: KNC.kr("sync", 1).Klag(lagTime),
		syncfreq: KNC.kr("syncfreq", 101, spec: Spec.specs[\freq]).Klag(lagTime)
	);
}, numChannelsIn: 1);
)
