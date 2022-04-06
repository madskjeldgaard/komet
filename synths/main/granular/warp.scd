(
	[1, 2].do{|numChansIn|
	K.add("warpi%".format(numChansIn), {|dur, buffer|
        var lagTime = \lagTime.kr(1);
		var rate = K_NC.kr("positionRate", 0.5).Klag(lagTime);
		var pointer = LFSaw.ar(rate.Klag(lagTime)).range(0.0,1.0);
		var shape = KGrainShapes().getWrap();
		var sig = Warp1.ar(
			numChannels: numChansIn,
			bufnum: buffer,
			pointer: pointer,
			freqScale: K_NC.kr("grainfreqScale", 1).Klag(lagTime),
			windowSize: K_NC.kr("grainsize", 0.1).Klag(lagTime),
			envbufnum: shape,
			overlaps: K_NC.kr("grainoverlap", 2).Klag(lagTime),
			windowRandRatio: K_NC.kr("windowrand", 0.9).Klag(lagTime),
			interp: 4
		);

		LeakDC.ar(sig);
	}, numChannelsIn: numChansIn);

	};

	// [1].do{|numChans|
	// K.add("warpoverlap%".format(numChans), {|buffer|
	// 	var rate = K_NC.kr("grainrate", 0.5);

	// 	var sig = WarpOverlap.ar(numChans: numChans,
	// 		buffer: buffer,
	// 		stretch: rate,
	// 		starttime: K_NC.kr("starttime", 0.5),
	// 		harm: K_NC.kr("grainfreqScale", 1),
	// 		windowsize: K_NC.kr("overlapWindows", 6),
	// 		step: K_NC.kr("warpstep", 1),
	// 		warpwindowoverlaps: K_NC.kr("grainoverlap", 8),
	// 		overlaps: 8,
	// 		warpwindowsize: K_NC.kr("grainsize", 0.1),
	// 		warpwindowran: K_NC.kr("windowrand", 0.5)
	// 	).poll;

	// 	LeakDC.ar(sig);
	// }, numChannelsIn: numChans);

	// }
)
