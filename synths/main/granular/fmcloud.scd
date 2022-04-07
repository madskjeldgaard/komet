(
var basename = "fmcloud";

K.add(basename, {|dur|
    var lagTime = \lagTime.kr(1);
	var grainFreq = K_NC.kr("grainDensity", 10.0).klag(lagTime);
	var interGrainRatio = K_NC.kr("interGrainRatio", 1.01).klag(lagTime);
	var amountFeedback = K_NC.kr("feedback", 0.95).klag(lagTime);

	var numGrains = 4;
	var feedback = LocalIn.ar(numGrains);
	var sig = Array.fill(numGrains, {|grainNum|
		var thisGrain, thisGrainPanner;
		var trigger = Dust2.kr(grainFreq * (grainNum+1));
		var driftParam = K_NC.kr("drift", 0.01);
		var drift = LFNoise2.kr(1).range(1,1+driftParam);
		var drift2 = LFNoise2.kr(1.1).range(1,1+driftParam);
		grainNum = grainNum + 1;

		thisGrain = FMGrain.ar(
			trigger: trigger,
			dur: K_NC.kr("graindur", 0.002) * (grainNum/numGrains/2 + 1),
			carfreq: K_NC.kr("grainCarFreq", 1200).klag(lagTime) * grainNum * interGrainRatio * drift,
			modfreq: K_NC.kr("grainModFreq", 100).klag(lagTime) * grainNum * interGrainRatio * drift2,
			index: K_NC.kr("grainFMIndex", 1.01).klag(lagTime) * grainNum * interGrainRatio,
		);
		thisGrain = thisGrain + (feedback[grainNum%numGrains] * amountFeedback) / 2.0;
		thisGrain = thisGrain * LFNoise2.kr(1).range(0.95,1.0);
		thisGrainPanner = LFNoise2.kr(Rand(0.01,0.25));
		Pan2.ar(thisGrain, thisGrainPanner);
	});

	LocalOut.ar(LeakDC.ar(LPF.ar(sig, 1500).tanh));

	sig.sum / numGrains

}, numChannelsIn:2);

)
