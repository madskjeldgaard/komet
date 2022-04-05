(
K.add("vosim", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	VosimOsc.ar(
		freq: (KNC.kr("freq", 100) + freqOffset).Klag(lagTime),
		form1freq: KNC.kr("form1freq", 1054, spec: Spec.specs[\freq]).Klag(lagTime),
		form2freq: KNC.kr("form2freq", 454, spec: Spec.specs[\freq]).Klag(lagTime),
		shape: KNC.kr("shape", 0, spec: [-1.0,1.0]).Klag(lagTime)
	);

	}, numChannelsIn: 1);
)
