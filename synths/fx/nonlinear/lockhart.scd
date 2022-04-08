(
K_FX.addFX(
    basename: \lockhart,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                \LockhartWavefolder.asClass.perform(
                    \ar,
                    input:sig * \wavefold.kr(0.01).linexp(0.00000000000001,1.0,1.0,20.0).klag(lagTime),
                    numCells:\cells.ir(4),
                )
            })
        }
    },
    type: \channelized,
    specs:(
        gain: [0.0, 1.0],
        cells: [1, 10],
    ),
    check: { \LockhartWavefolder.asClass.notNil }

);
)
