(
// Originally from https://github.com/alikthename/Musical-Design-in-Supercollider/blob/master/1_sin_pulsar.sc
K.add(\sinpulsar, {|dur|
	var a,b,c,d,e,f, f_, fund ,t,lev, formantA, formantB, overlapA, overlapB;
	var shape1 = KGrainShapes().getWrap(suffix: "1");
	var shape2 = KGrainShapes().getWrap(suffix: "2");
	var shape3 = KGrainShapes().getWrap(suffix: "3");
    var lagTime = \lagTime.kr(1);
	lev = \level.kr(0.9).Klag(lagTime);
	f = \freq.kr(440).Klag(lagTime);
	f_ = f.clip(50, 1500);

	formantA = \formantA.kr(4).Klag(lagTime);
	formantB = \formantB.kr(6).Klag(lagTime);
	overlapA = \overlapA.kr(2).Klag(lagTime);
	overlapB = \overlapB.kr(9).Klag(lagTime);

	fund = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur:  overlapA * dur
		// dur: Rand(0.5,2)  * ( 0.05 + e.pow(0.5) )
		/ f,
		envbufnum: shape1,
		freq: f,
	);

	a = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur:  overlapA * dur
		// dur:  overlapA * ( 0.05 + e.pow(0.5) )
		/ f,
		envbufnum: shape2,
		freq: f * formantA,
	);

	b = GrainSin.ar(
		numChannels: 1,
		trigger: Impulse.ar(f),
		dur:  overlapB * dur
		// dur:  overlapB * ( 0.05 + e.pow(0.5) )
		/ f,
		freq: f * formantB,
		envbufnum: shape3,
	);

	c = Mix([
		fund * ( lev ).pow(0.7),
		a * ( lev ).pow(f_.linlin( 50, 1500, 1.1, 1.5)),
		b * ( lev ).pow(f_.linlin( 50, 1500, 1.5, 2.5)),
	]);

	LeakDC.ar(c);
});
)
