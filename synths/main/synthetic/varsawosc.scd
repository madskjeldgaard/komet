(
KometSynthFactory.add("varsaw", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	NeoVarSawOsc.ar(
		freq: (K_NC.kr("freq", 100, spec: Spec.specs[\freq]) + freqOffset).klag(lagTime),
		pw: K_NC.kr("pw", 0.5).klag(lagTime),  waveshape: K_NC.kr("waveshape", 0.5).klag(lagTime)
	)
	}, numChannelsIn: 1);
)
