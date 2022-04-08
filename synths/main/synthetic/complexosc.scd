// Buchla 261 Complex Waveform Generator inspired
(
["", "_lpg", "_folded", "_lpg_folded"].do{|version|
    var addWavefolder = version.contains("folded");
    var addLPG = version.contains("lpg");

	KometSynthFactory.add("complex" ++ version,  {|dur, freq=440, freqOffset=0, modFreq=100, amMod=0, fmMod=0|
		// var modulator = SinOsc.ar(freq: modulatorFreq,  phase: 0.0);
        var am, fm, sig, modulator, timbreMod;

        var lagTime = \lagTime.kr(1);
        freq = (freq + freqOffset).klag(lagTime);

        timbreMod=K_NC.ar("timbreMod", 0).klag(lagTime);

		modulator = Squine.ar(
			freq: modFreq.klag(lagTime),
			clip: K_NC.kr("clip", 0, prefix: "mod").klag(lagTime),
			skew: K_NC.kr("skew", 0, prefix:"mod").klag(lagTime),
			initphase: K_NC.kr("phase", 1.25, prefix:"mod").klag(lagTime)
		);

		fm = modulator.range(
			(1.0 - fmMod.klag(lagTime)) * freq,
			freq
		)
		.lag(Rand(0.001,0.01));

		// var sig = SinOsc.ar(freq: fm,  phase: 0.0);
		sig = Squine.ar(
			freq: fm,
			clip: K_NC.kr("clip", 0, prefix: "main").klag(lagTime),
			skew: K_NC.kr("skew", 0, prefix:"main").klag(lagTime),
			initphase: K_NC.kr("phase", 1.25, prefix:"main").klag(lagTime)
		);

		am;

        am = modulator.range(
			(1.0 - amMod.klag(lagTime)) * 1,
			1
		).lag(Rand(0.001,0.01));

		sig  = sig * am;

        // Optional wavefolder
        if(addWavefolder, {
            var wavefold=K_NC.ar("wavefold", 0.1).klag(lagTime), numCells=K_NC.ir("cells", 4);
            var gain = wavefold.linexp(0.00000000000001,1.0,1.0,20.0);

            gain = modulator.range(
                (1.0 - timbreMod) * gain,
                gain
            )
            .lag(Rand(0.001,0.01));

            sig = sig * LockhartWavefolder.ar(input: sig * gain,  numCells: numCells);
        });

        // Optional lowpass gate
		if(addLPG, {
			var lpgenv = KEnvelopes().getWrap(\perc, "lpg", "", dur, 0);

			sig = LPG.ar(
				input: sig,
				controlinput: lpgenv,
				controloffset: K_NC.kr(name: "offset",  values: 1,  suffix: "lpg"),
				controlscale: K_NC.kr(name: "controlscale",  values: 1,  suffix: "lpg"),
				vca: K_NC.kr(name: "vca",  values: 1,  suffix: "lpg"),
				resonance: K_NC.kr(name: "resonance",  values: 1.5,  suffix: "lpg"),
				lowpassmode: K_NC.kr(name: "lowpassmode",  values: 1,  suffix: "lpg"),
				linearity: K_NC.kr(name: "linearity",  values: 1,  suffix: "lpg"),
			);

		});

		sig

	},  numChannelsIn: 1);
}
)
