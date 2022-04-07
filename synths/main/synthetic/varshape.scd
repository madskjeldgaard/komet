(
K.add("varshape", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	VarShapeOsc.ar(
		freq: (K_NC.kr("freq", 100) + freqOffset).klag(lagTime),
		pw: K_NC.kr("pw", 0.5).klag(lagTime),
		waveshape: K_NC.kr("shape", 0.5).klag(lagTime),
		sync: K_NC.kr("sync", 1).klag(lagTime),
		syncfreq: K_NC.kr("syncfreq", 101, spec: Spec.specs[\freq]).klag(lagTime)
	);
}, numChannelsIn: 1);
)
