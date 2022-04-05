(
K.add("varsaw", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	NeoVarSawOsc.ar(
		freq: (K_NC.kr("freq", 100, spec: Spec.specs[\freq]) + freqOffset).Klag(lagTime),
		pw: K_NC.kr("pw", 0.5).Klag(lagTime),  waveshape: K_NC.kr("waveshape", 0.5).Klag(lagTime)
	)
	}, numChannelsIn: 1);
)
