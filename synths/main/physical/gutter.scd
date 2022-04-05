(
K.add(
	basename: \gutter,
	synthfunc: {|dur|
		var sig, freq1, freq2, pitch;
        var mod, omega, damp, rate, gain, soften, gain1, gain2, q1, q2;
        var lagTime = \lagTime.kr(1);

        mod = \mod.kr(0.2, spec:[0,10]).Klag(lagTime);
        omega = \omega.kr(0.0002, spec:ControlSpec(0.0001, 1, \exponential)).Klag(lagTime);
        damp = \damp.kr(0.01, spec:ControlSpec(0.0001, 1, \exponential)).Klag(lagTime);
        rate = \rate.kr(0.03, spec:[0, 5]).Klag(lagTime);
        gain = \gain.kr(1.4, spec:[0, 3.5]).Klag(lagTime);
        soften = \soften.kr(1, spec:[0, 5]).Klag(lagTime);
        gain1 = \gain1.kr(1.5, spec:[0.0, 2.0, \lin]).Klag(lagTime);
        gain2 = \gain2.kr(1.5, spec:[0.0, 2.0, \lin]).Klag(lagTime);
        q1 = \q.kr(20, spec:ControlSpec(0.5, 800, \exponential)).Klag(lagTime);

        // freq = [56, 174, 194, 97, 139, 52, 363, 118, 353, 629];
        pitch = \pitchShift.kr(0.25, spec: [0.05,2.0]).Klag(lagTime);
        freq1 = pitch * [ 104.08913805616, 272.0241439869, 142.5394121681, 740.98235420089, 3231.1092775615, 598.48984613932, 564.11122601617, 152.53849023618, 4773.6198870775, 798.26171948236, 729.54452005837, 734.37542510625, 661.89936380362, 133.46101940276, 1715.6115033359, 11658.962024239, 6408.5610397899, 11775.302108311, 857.52846512925, 2020.251581889, 14168.220304686, 192.17654523236, 326.55730188427, 4386.8490423436];
        freq2 = freq1 * Array.rand(freq1.size, 0.95,1.0);

        // q = q ! freq1.size;
        q1 = Array.rand(freq1.size, 0.95,1.0) * q1;
        q2 = Array.rand(freq1.size, 0.95,1.0) * q1;

        sig = GutterSynth.ar(
            gamma:         mod,
            omega:         omega,
            c:             damp,
            dt:         rate,
            singlegain: gain,
            smoothing:  soften,
            togglefilters: 1,
            distortionmethod: \distortionmethod.kr(1, spec: [0,4,\lin,1]),
            oversampling: 1,
            enableaudioinput: 0,
            audioinput: SinOsc.ar(SinOsc.ar(LFNoise2.ar(30)*100).exprange(100.0,2500.0)),
            gains1:     gain1,
            gains2:     gain2,
            freqs1:     `freq1,
            qs1:         `q1,
            freqs2:     `freq2,
            qs2:         `q2,
        );

        sig = SafetyLimiter.ar(sig);
		sig = LeakDC.ar(sig);

	},
	numChannelsIn: 1);
)
