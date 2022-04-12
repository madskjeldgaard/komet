(
var envs = ();

envs.adsr = { |prefix, suffix|
	{|dur=1, envDone=2|
		var attack=K_NC.kr("attack", 0.1, suffix: suffix, prefix: prefix),
		release=K_NC.kr("release", 0.9, suffix: suffix, prefix: prefix),
		envcurve=K_NC.kr("envcurve", -5.0, suffix: suffix, prefix: prefix),
		gate=K_NC.kr("gate", 1),
		legato = K_NC.kr("legato", 1),
		decay=K_NC.kr("decay", 0.3, suffix: suffix, prefix: prefix),

		bias=0,
		sustainLevel = K_NC.kr("sustainLevel", 0.95, suffix: suffix, prefix: prefix);

		dur = legato * dur;

		EnvGen.kr(
            Env.adsr(
                attackTime:attack,
                decayTime:decay,
                sustainLevel:sustainLevel,
                releaseTime:release,
                peakLevel:1,
                curve:envcurve,
                bias:bias
            ),
			gate: gate,
			timeScale: dur,
			levelBias: 0,
			levelScale: 1.0,
			doneAction: envDone
		).poll
	}
};

// Same as Env.adsr but with release node set to nil to make it triggered
// envs.tadsr = { |prefix, suffix|
// 	{ |dur=1, envDone=2|
// 		var attack=K_NC.kr("attack", 0.01, suffix: suffix, prefix: prefix),
// 		decay=K_NC.kr("decay", 0.3, suffix: suffix, prefix: prefix),
// 		sustainLevel=K_NC.kr("sustainLevel", 0.5, suffix: suffix, prefix: prefix),
// 		release=K_NC.kr("release", 1.0, suffix: suffix, prefix: prefix),
// 		peakLevel=K_NC.kr("peakLevel", 1.0, suffix: suffix, prefix: prefix),
// 		curve = K_NC.kr("curve", -4.0, suffix: suffix, prefix: prefix),
// 		bias = K_NC.kr("bias", 0.0, suffix: suffix, prefix: prefix),
// 		gate=K_NC.kr("gate", 1),
// 		legato = K_NC.kr("legato", 1);
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
		var attack=K_NC.kr("attack", 0.1, suffix: suffix, prefix: prefix),
		release=K_NC.kr("release", 0.9, suffix: suffix, prefix: prefix),
		envcurve=K_NC.kr("envcurve", -5.0, suffix: suffix, prefix: prefix),
		gate=K_NC.kr("gate", 1),
		legato = K_NC.kr("legato", 1);

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
		var gate = K_NC.kr("gate", 1, prefix:prefix, suffix: suffix);
		var legato = K_NC.kr("legato", 1);
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
