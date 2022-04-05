(
(1..2).do{|numIn|
	M.add(basename: "clouds%in".format(numIn),  synthfunc: {
		|dur, buffer, bufferRate=0.5, pitch=0.5, grainsize=0.25, density=0.6, position=0.0, spread=0.5, freeze=0, texture=0.0, drywet=1, reverb=0, feedback=0, mode=0, lofi=0|
        var lagTime = \lagTime.kr(1);
		var rate, input;

		var pitchEnv = KEnvelopes().getWrap(\adsr, "pitch", "", dur, 0);
		var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0);
		rate = bufferRate.Klag(lagTime);

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
			pos: position.Klag(lagTime),
			size: grainsize.Klag(lagTime),
			dens: density.Klag(lagTime),
			tex: texture.Klag(lagTime),
			drywet: drywet.Klag(lagTime),
			in_gain: 1,
			spread: spread.Klag(lagTime),
			rvb: reverb.Klag(lagTime),
			fb: feedback.Klag(lagTime),
			freeze: freeze.Klag(lagTime),
			mode: mode,
			lofi: lofi,
			trig: 0
		);

	},  numChannelsIn: 2);
}
)
