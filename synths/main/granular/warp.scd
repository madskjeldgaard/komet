(
	[1, 2].do{|numChansIn|
	M.add("warpi%".format(numChansIn), {|dur, buffer|
        var lagTime = \lagTime.kr(1);
		var rate = KNC.kr("positionRate", 0.5).Klag(lagTime);
		var pointer = LFSaw.ar(rate.Klag(lagTime)).range(0.0,1.0);
		var shape = KGrainShapes().getWrap();
		var sig = Warp1.ar(
			numChannels: numChansIn,
			bufnum: buffer,
			pointer: pointer,
			freqScale: KNC.kr("grainfreqScale", 1).Klag(lagTime),
			windowSize: KNC.kr("grainsize", 0.1).Klag(lagTime),
			envbufnum: shape,
			overlaps: KNC.kr("grainoverlap", 2).Klag(lagTime),
			windowRandRatio: KNC.kr("windowrand", 0.9).Klag(lagTime),
			interp: 4
		);

		LeakDC.ar(sig);
	}, numChannelsIn: numChansIn);

	};

	// [1].do{|numChans|
	// M.add("warpoverlap%".format(numChans), {|buffer|
	// 	var rate = KNC.kr("grainrate", 0.5);

	// 	var sig = WarpOverlap.ar(numChans: numChans,
	// 		buffer: buffer,
	// 		stretch: rate,
	// 		starttime: KNC.kr("starttime", 0.5),
	// 		harm: KNC.kr("grainfreqScale", 1),
	// 		windowsize: KNC.kr("overlapWindows", 6),
	// 		step: KNC.kr("warpstep", 1),
	// 		warpwindowoverlaps: KNC.kr("grainoverlap", 8),
	// 		overlaps: 8,
	// 		warpwindowsize: KNC.kr("grainsize", 0.1),
	// 		warpwindowran: KNC.kr("windowrand", 0.5)
	// 	).poll;

	// 	LeakDC.ar(sig);
	// }, numChannelsIn: numChans);

	// }
)
