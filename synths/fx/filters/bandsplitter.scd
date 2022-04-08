(
KometFXFactory.add(
    basename: \split2,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                Krossover2.ar(
                    sig,
                    \freq.kr(1000).klag(lagTime)
                )
            })
        }
    },
    type: \channelized,
    specs:(
        freq: Spec.specs[\freq],
    ),
);

KometFXFactory.add(
    basename: \split4,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                Krossover4.ar(
                    sig,
                    \freq1.kr(100).klag(lagTime),
                    \freq2.kr(1000).klag(lagTime),
                    \freq3.kr(10000).klag(lagTime),
                )
            })
        }
    },
    type: \channelized,
    specs:(
        freq1: Spec.specs[\freq],
        freq2: Spec.specs[\freq],
        freq3: Spec.specs[\freq],
    ),
);

)
