(
var filters = ();

filters.none = {|prefix="", suffix="", filterEnvType|
	{|sig, dur, envDone|
		sig
	}
};

filters.vadim = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);

		var type = KNC.ir("filterType", 1, spec: [0,5]);
		var resonance = KNC.kr("resonance", 0.5);

		VadimFilter.ar(input: sig, freq: cutoff, resonance: resonance, type: type)
	}
};

// filters.dummy = {|prefix="", suffix="", filterEnvType=\adsr|
// 	{|sig, dur, envDone=0|
// 		KEnvelopes().getWrap(\adsr).poll;
// 	}
// };

filters.korg35 = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);
		var resonance = KNC.ar("resonance", 0.0,prefix:prefix, suffix:suffix);
		var overdrive = KNC.ar("overdrive", 0.0,prefix:prefix, suffix: suffix);
		var type = KNC.ar("type", 0.0,prefix:prefix, suffix: suffix);

		VAKorg35.ar(input: sig,  freq: cutoff,  res: resonance,  overdrive: overdrive,  type: type);
	}
};

filters.vasem12 = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);

		var resonance = KNC.ar("resonance", 0.0,prefix:prefix, suffix:suffix);
		var transition = KNC.ar("transition", 0.0,prefix:prefix, suffix: suffix);

		VASEM12.ar(input: sig,  freq: cutoff,  res: resonance,  transition: transition);
	}
};

filters.diode = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);
		var resonance = KNC.ar("resonance", 0.0,prefix:prefix, suffix:suffix);
		var overdrive = KNC.ar("overdrive", 0.0,prefix:prefix, suffix: suffix);
		var type = KNC.ar("type", 0.0,prefix:prefix, suffix: suffix);

		VADiodeFilter.ar(input: sig,  freq: cutoff,  res: resonance,  overdrive: overdrive);
	}
};

filters.ladder = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		// Filter envelope stuff
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);
		var resonance = KNC.ar("resonance", 0.0,prefix:prefix, suffix:suffix);
		var overdrive = KNC.ar("overdrive", 0,prefix:prefix, suffix: suffix);
		var type = KNC.ar("type", 0.0,prefix:prefix, suffix: suffix);

		VALadder.ar(input: sig,  freq: cutoff,  res: resonance,  overdrive: overdrive,  type: type);
	}
};

filters.dfm1 = {|prefix="", suffix="", filterEnvType=\adsr|
	{|sig, dur, envDone=0|
		// Filter envelope stuff
		var filterLag = KNC.kr("lag", 0.1, prefix: prefix, suffix: suffix);
		var filterEnv = KEnvelopes().getWrap(filterEnvType, "f", "", dur, envDone);
		var filterEnvPeak = KNC.kr("envPeak", 1, prefix: prefix, suffix: suffix);
		var cutoffParam = KNC.kr("cutoff", 20000, prefix: prefix, suffix: suffix);
		var filterEnvParam = KNC.kr("envAmount", 0.0, prefix: prefix, suffix: suffix);
		var cutoff = SelectX.kr(filterEnvParam, [
			cutoffParam, filterEnv.linlin(0.0,1.0,20.0, clip(cutoffParam * filterEnvPeak, 20.0,20000.0))
		]);

		DFM1.ar(
			sig,
			cutoff,
			KNC.ar("resonance", 0.0,prefix:prefix, suffix:suffix),
			KNC.ar("gain", 1.0,prefix:prefix, suffix: suffix),
			KNC.ar("type", 0.0,prefix:prefix, suffix: suffix),
			KNC.kr("noise", 0.0,prefix:prefix, suffix: suffix)
		)

	}
};

filters
)
