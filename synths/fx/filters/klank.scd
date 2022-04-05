(
K_FX.addFX(
    basename: \klank,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            var freqs = \freqs.kr([100,400,800,2500]);
            var amps = \amps.kr([1,0.5,0.25,0.85]);
            var rings = \rings.kr([0.5,0.5,0.5,0.5]);
            // var specArray = \specArray.kr([, nil, [1, 1, 1, 1]]);

            var output = Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var lagTime = \lagTime.kr(1);
                var spread = 1+(\spread.kr(0.1)*chanNum);

                DynKlank.ar(
                    specificationsArrayRef:`[freqs, amps, rings],
                    input:sig * 0.1,
                    freqscale: MKNC.kr("freqscale", 1).mklag(lagTime) * spread,
                    freqoffset: MKNC.kr("freqoffset", 0).mklag(lagTime),
                    decayscale: MKNC.kr("decayscale", 0.1).mklag(lagTime)
                ) * 0.5
            });

            SafetyLimiter.ar(output)
        }
    },
    type: \channelized,
    specs:(
        freqscale: [0.001,4.0, \lin]
    ),
)
)
