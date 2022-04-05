// Originally from https://github.com/alikthename/Musical-Design-in-Supercollider/blob/master/1_sin_pulsar.sc
(
K.add(\fmpulsar, {|dur|
	var a,f;
	var t, overlap, carfreq, modfreq, mInd, vel, vel_;
    var lagTime = \lagTime.kr(1);
	var shape = KGrainShapes().getWrap();

	f = \freq.kr(100).Klag(lagTime);
	f = f + SinOsc.ar(LFNoise1.kr(0.3!2).range(1,4));

	vel = \velocity.kr(0.5).Klag(lagTime);
	vel_ = vel.clip(0,1.0).linlin( 0, 1, 2, 0.7);

	carfreq = f * \carrierFreq.kr(2).Klag(lagTime) + LFNoise1.kr(3).range(0,50);
	modfreq = carfreq * \modulatorFreq.kr(2).Klag(lagTime) +  LFNoise1.kr(3).range(0,100);

	t = Impulse.ar(f);
	mInd = LFNoise2.kr(5!2).range(\modulatorIndexMin.kr(0.1).Klag(lagTime),\modulatorIndexMax.kr(2.3).Klag(lagTime));
	overlap = 1.1 - LFNoise1.kr(0.3!2).range(\overlapMin.kr(1).Klag(lagTime),\overlapMax.kr(8).Klag(lagTime));
	d = overlap/f;

	a = SinOsc.ar(f)+
		GrainFM.ar( 1, t, d, carfreq, modfreq, mInd, envbufnum: shape );

	LeakDC.ar(a );
}, numChannelsIn: 2)
)
