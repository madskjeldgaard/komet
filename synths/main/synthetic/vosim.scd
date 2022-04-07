(
K.add("vosim", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);
	VosimOsc.ar(
		freq: (K_NC.kr("freq", 100) + freqOffset).klag(lagTime),
		form1freq: K_NC.kr("form1freq", 1054, spec: Spec.specs[\freq]).klag(lagTime),
		form2freq: K_NC.kr("form2freq", 454, spec: Spec.specs[\freq]).klag(lagTime),
		shape: K_NC.kr("shape", 0, spec: [-1.0,1.0]).klag(lagTime)
	);

	}, numChannelsIn: 1);
)
