import("stdfaust.lib");

// process = co.limiter_1176_R4_mono;
process = co.limiter_lad_mono(LD, ceiling, attack, hold, release) with {
	// * `LD` is the lookahead delay in seconds, known at compile-time
	LD=0.002;
	// * `ceiling` is the linear amplitude output limit
	ceiling = vslider("ceiling",0.95,0.00001,1,0.0001);
	// * `attack` is the attack time in seconds
	attack = vslider("attack",0.001,0.00000001,2,0.0001);
	// * `hold` is the hold time in seconds
	hold = vslider("hold",0.5,0.00000001,3,0.0001);
	// * `release` is the release time in seconds
	release = vslider("release",0.01,0.00000001,2,0.0001);
};
