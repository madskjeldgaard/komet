(
	M.add(\grainsin, {|dur, freq=100, density=10, graindur=0.1, panwidth=0.5|
        var lagTime = \lagTime.kr(1);
		var trigger = Dust2.ar(density.Klag(lagTime));
		var maxgrains = 512;
		var numchannels = 2;
		var shape = KGrainShapes().getWrap();

		GrainSin.ar(numchannels,
			trigger,
			graindur.Klag(lagTime),
			freq.Klag(lagTime),
			panwidth * LFNoise2.kr(1),
			envbufnum: shape,
			maxGrains: maxgrains
		);

	}, numChannelsIn: 2);
)
