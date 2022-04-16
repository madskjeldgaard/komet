(
var desc = "A wavefolder",
    func = {|numChannels|
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
    type = \fx,
    category = \channelized,
    basename = \lockwart,
    numChans = nil, // TODO: Not used
    specs = (
        gain: [0.0, 1.0],
        cells: [1, 10],
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

)
