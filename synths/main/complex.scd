// Buchla 261 Complex Waveform Generator inspired
(
["", "_lpg", "_folded", "_lpg_folded"].do{|version|
    var desc = "A Buchla 261 Complex Waveform Generator inspired synth";
    var addWavefolder = version.contains("folded");
    var addLPG = version.contains("lpg");
    var name = ("complex" ++ version).asSymbol;
	var func =  {|dur, freq=440, freqOffset=0, modFreq=100, amMod=0, fmMod=0|
        var am, fm, sig, modulator, timbreMod;

        var lagTime = \lagTime.kr(1);
        freq = freq + freqOffset.klag(lagTime);
        freq = freq.kWithPitchEnv(
                dur,
                K_NC.kr("pitchEnvAmount", 0).klag(lagTime),
                envType:\adsr
            );
        freq = freq.kWithWow(
            K_NC.kr("wow", 0.0),
            wowMinFreq:0.01,
            wowMaxFreq: 10.0
        );
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

	};
    var type = \synth;
    var category = \synthetic;
    var basename = name;
    var numChans = 1;
    var specs = (
        freq: Spec.specs[\freq],
        freqOffset:\freqOffset,
        modFreq:\lfofreq,
        amMod:[0.0,1.0],
        fmMod:[0.0,1.0],
        timbreMod:[0.0,1.0],
        mainclip:[0.0,1.0],
        mainskew: [-1.0,1.0],
        mainphase: [0.0,2.0],
        modclip:[0.0,1.0],
        modskew: [-1.0,1.0],
        modphase: [0.0,2.0],
        wavefold: [0.0,1.0],
        cells: [1,8],
        lpgattack: [0.00001,1.0],
        lpgrelease: [0.00001,1.0],
        lpgenvcurve: [-10,10],
        lpgoffset:[0.0,1.0],
        lpgcontrolscale:[0.0,1.0],
        lpgvca: [0.0,1.0],
        lpgresonance: [0.0,1.8],
        lpglowpassmode: [0,1],
        lpglinearity: [0,1]

    );
    KometSynthFuncDef(
        basename,
        func,
        type,
        category,
        numChans,
        desc,
        specs,
    ).add();

}
)
