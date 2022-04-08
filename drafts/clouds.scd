(
(1..2).do{|numIn|
	KometSynthFactory.add(basename: "clouds%in".format(numIn),  synthfunc: {
		|dur, buffer, bufferRate=0.5, pitch=0.5, grainsize=0.25, density=0.6, position=0.0, spread=0.5, freeze=0, texture=0.0, drywet=1, reverb=0, feedback=0, mode=0, lofi=0|
        var lagTime = \lagTime.kr(1);
		var rate, input;

		var pitchEnv = KEnvelopes().getWrap(\adsr, "pitch", "", dur, 0);
		var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0);
		rate = bufferRate.klag(lagTime);

		rate = pitchEnv.linlin(
			0.0,
			1.0,
			rate + (rate * pitchenvAmount),
			rate - (rate * pitchenvAmount)
		);

		input = PlayBuf.ar(numIn,  buffer ,BufRateScale.kr(buffer) * rate, loop: 1);

		if(numIn > 1, { input = input.sum });

		MiClouds.ar(
			input,
			pit: pitch.linlin(0.0,1.0,(-48.0), 48.0),
			pos: position.klag(lagTime),
			size: grainsize.klag(lagTime),
			dens: density.klag(lagTime),
			tex: texture.klag(lagTime),
			drywet: drywet.klag(lagTime),
			in_gain: 1,
			spread: spread.klag(lagTime),
			rvb: reverb.klag(lagTime),
			fb: feedbacKometSynthFactory.klag(lagTime),
			freeze: freeze.klag(lagTime),
			mode: mode,
			lofi: lofi,
			trig: 0
		);

	},  numChannelsIn: 2);
}
)
