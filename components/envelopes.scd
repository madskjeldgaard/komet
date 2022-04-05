(
var envs = ();

envs.adsr = { |prefix, suffix|
	{|dur=1, envDone=2|
		var attack=KNC.kr("attack", 0.1, suffix: suffix, prefix: prefix),
		release=KNC.kr("release", 0.9, suffix: suffix, prefix: prefix),
		envcurve=KNC.kr("envcurve", -5.0, suffix: suffix, prefix: prefix),
		gate=KNC.kr("gate", 1),
		legato = KNC.kr("legato", 1),
		decay=KNC.kr("decay", 0.3, suffix: suffix, prefix: prefix),
		peakLevel=KNC.kr("peakLevel", 1.0, suffix: suffix, prefix: prefix),
		bias=0,
		sustainLevel = KNC.kr("sustainLevel", 0.95, suffix: suffix, prefix: prefix);

		dur = legato * dur;

		EnvGen.kr(
			Env.new(
				levels: [0, peakLevel, peakLevel * sustainLevel, 0] + bias,
				times: [attack, decay, release],
				curve: envcurve,
				releaseNode: 2
			),
			gate: gate,
			timeScale: dur,
			levelBias: 0,
			levelScale: 1.0,
			doneAction: envDone
		)
	}
};

// Same as Env.adsr but with release node set to nil to make it triggered
// envs.tadsr = { |prefix, suffix|
// 	{ |dur=1, envDone=2|
// 		var attack=KNC.kr("attack", 0.01, suffix: suffix, prefix: prefix),
// 		decay=KNC.kr("decay", 0.3, suffix: suffix, prefix: prefix),
// 		sustainLevel=KNC.kr("sustainLevel", 0.5, suffix: suffix, prefix: prefix),
// 		release=KNC.kr("release", 1.0, suffix: suffix, prefix: prefix),
// 		peakLevel=KNC.kr("peakLevel", 1.0, suffix: suffix, prefix: prefix),
// 		curve = KNC.kr("curve", -4.0, suffix: suffix, prefix: prefix),
// 		bias = KNC.kr("bias", 0.0, suffix: suffix, prefix: prefix),
// 		gate=KNC.kr("gate", 1),
// 		legato = KNC.kr("legato", 1);
// 		dur = legato * dur;

// 		EnvGen.kr(
// 			Env.new(
// 				[0, peakLevel, peakLevel * sustainLevel, 0] + bias,
// 				[attack, decay, release],
// 				curve
// 			),
// 			gate: gate,
// 			timeScale:dur,
// 			levelBias: 0,
// 			levelScale: 1.0,
// 			doneAction: envDone
// 		)
// 	}
// };

envs.perc = { |prefix, suffix|
	{|dur=1, envDone=2|
		var attack=KNC.kr("attack", 0.1, suffix: suffix, prefix: prefix),
		release=KNC.kr("release", 0.9, suffix: suffix, prefix: prefix),
		envcurve=KNC.kr("envcurve", -5.0, suffix: suffix, prefix: prefix),
		gate=KNC.kr("gate", 1),
		legato = KNC.kr("legato", 1);

		dur = legato * dur;

		EnvGen.kr(
		Env.perc(attack, release,  level: 1.0,  curve: envcurve),
			gate: gate,
			timeScale:dur ,
			levelBias: 0,
			levelScale: 1.0,
			doneAction: envDone
		)
	}
};

envs.gate = { |prefix, suffix|
	{|dur=1, envDone=2|
		var gate = KNC.kr("gate", 1, prefix:prefix, suffix: suffix);
		var legato = KNC.kr("legato", 1);
		dur = legato * dur;

		EnvGen.kr(
			Env.new(levels: [0,1,1,0],times: [ 0.0,1, 0.0 ],curve: \lin),
			gate: gate,
			timeScale:dur,
			levelBias: 0,
			levelScale: 1.0,
			doneAction: envDone
		)
	}
};

envs.none = { |prefix, suffix|
	{|dur=1, envDone=2|
        1
	}
};

envs;
)
