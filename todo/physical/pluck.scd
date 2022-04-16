(
KometSynthFactory.add(\pluck,  synthfunc: {
	|dur, pluckLevel=0.5, pluckDur=0.01, freq=440, pluckDecay=5, pluckCoef=0.1, pluckMaxDelay=0.015|
	var trig = Trig1.ar(1, pluckDur);
    var lagTime = \lagTime.kr(1);

	Pluck.ar(
		in: WhiteNoise.ar(pluckLevel),
		trig: trig,
		maxdelaytime: pluckMaxDelay,
		delaytime: freq.reciprocal.klag(lagTime),
		decaytime: pluckDecay.klag(lagTime),
		coef: pluckCoef.klag(lagTime)
	);

},  numChannelsIn: 1);
)