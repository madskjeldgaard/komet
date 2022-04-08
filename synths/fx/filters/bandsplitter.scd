(
KometFXFactory.addFX(
    basename: \split2,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                BandSplitter2.ar(
                    sig:sig,
                    freq:\freq.kr(1000).klag(lagTime),
                    order:2
                )
            })
        }
    },
    type: \channelized,
    specs:(
        freq: Spec.specs[\freq],
    ),
);

KometFXFactory.addFX(
    basename: \split4,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                BandSplitter4.ar(
                    sig:sig,
                    f1:\freq1.kr(100).klag(lagTime),
                    f2:\freq2.kr(1000).klag(lagTime),
                    f3:\freq3.kr(10000).klag(lagTime),
                    order:2
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
