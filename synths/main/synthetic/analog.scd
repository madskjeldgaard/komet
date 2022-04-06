// @TODO rewrite this as one synth with variable waveshape
(
[DPW4Saw, BlitB3Tri, PulseDPW, SawDPW, DPW3Tri, SinOsc].do{|soundSource|

	var basename = "analog_%".format(soundSource.name.asString.toLower);

	K.add(basename, {
		arg dur, freq=100, freqOffset=0, freqModAmount=0.09, modFreq=5.5, detuneFreq=1, detuneModAmount=0.5, detuneModShape=0;
		var sig, modulators, detune;
        var lagTime = \lagTime.kr(1);

        freq = (freq + freqOffset).Klag(lagTime);
        modFreq = modFreq.Klag(lagTime);
        freqModAmount = freqModAmount.Klag(lagTime);
        detuneFreq = detuneFreq.Klag(lagTime);
        detuneModAmount = detuneModAmount.Klag(lagTime);
        detuneModShape = detuneModShape.Klag(lagTime);

		// Detune modulator
		modulators = [
			SinOsc.ar(modFreq),
			LFTri.ar(modFreq),
			LFSaw.ar(modFreq),
			LFNoise2.ar(modFreq),
		];

		detune = SelectX.ar(
			detuneModShape * modulators.size,
			modulators,
			wrap: 1
		);

		detune = detune.lag(Rand() * 0.01).Klag(lagTime);

		freq = detune.linexp(-1.0,1.0,freq,(1.0+freqModAmount) * freq);

		// Source sound
		soundSource.ar(
			freq:
			[
				freq,
				freq - detune.linexp(
					-1.0,
					1.0,
					0.0001,
					(detuneFreq * detuneModAmount) + 0.0001
				).lag(0.1)
			]

		).sum;
	}, numChannelsIn: 1);

};
)
