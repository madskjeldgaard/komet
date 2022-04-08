(
KometFXFactory.addFX(
    basename: \jpverb,
    synthfunc:
        {|in, t60=1, damp=0.1, size=3, earlyDiff=0.707, modDepth=0.9, modFreq=0.2, low=1, mid=1, high=1, lowcut=500, highcut=2000|

            var lagTime = \lagTime.kr(1);
            var sig = in;
            JPverb.ar(in:in, t60:t60.klag(lagTime), damp:damp.klag(lagTime), size:size.klag(lagTime), earlyDiff:earlyDiff, modDepth:modDepth.klag(lagTime), modFreq:modFreq.klag(lagTime), low:low, mid:mid, high:high, lowcut:lowcut, highcut:highcut);

    },
    type: \stereo, // channelized, stereo or ambisonic
    specs: (
		time: [0.0001, 100.0, \exp],
		damp: [0.0, 1.0, \lin],
		size: [0.0001, 5.0, \exp],
		earlyDiff: [0.0, 1.0, \lin],
		modDepth: [0.0, 1.0, \lin],
		modFreq: [0.0001, 10.0, \exp],
		low: [0.0, 1.0],
		mid: [0.0, 1.0],
		high: [0.0, 1.0],
		lowcut: Spec.specs[\freq],
		highcut: Spec.specs[\freq]
	)

);
)
