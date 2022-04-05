(
K.add("varsaw", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	NeoVarSawOsc.ar(
		freq: (KNC.kr("freq", 100, spec: Spec.specs[\freq]) + freqOffset).Klag(lagTime),
		pw: KNC.kr("pw", 0.5).Klag(lagTime),  waveshape: KNC.kr("waveshape", 0.5).Klag(lagTime)
	)
	}, numChannelsIn: 1);
)
