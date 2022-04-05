(
K_FX.addFX(
    basename: \pitchshift1,
    synthfunc: {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                PitchShift.ar(
                    in:sig,
                    windowSize:\windowSize.ir(0.25),
                    pitchRatio:\pitchRatio.kr(2).mklag(lagTime),
                    pitchDispersion:\pitchDispersion.kr(0.1).mklag(lagTime),
                    timeDispersion:\timeDispersion.kr(0.1).mklag(lagTime)
                )

            })
        }
    },
    type: \channelized, // channelized, stereo or ambisonic
    specs:(
		windowSize: [0.001, 1.0], pitchRatio: [0.0, 4.0], pitchDispersion: [0.0, 1.0], timeDispersion: [0.0, 1.0],
	)
);
)
