(
var desc = "Vanilla SC pitchshifter",
    func = {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                PitchShift.ar(
                    in:sig,
                    windowSize:\windowSize.ir(0.25),
                    pitchRatio:\pitchRatio.kr(2).klag(lagTime),
                    pitchDispersion:\pitchDispersion.kr(0.1).klag(lagTime),
                    timeDispersion:\timeDispersion.kr(0.1).klag(lagTime)
                )

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \pitchshift,
    numChans = nil, // TODO: Not used
    specs = (
        windowSize: [0.001, 1.0],
        pitchRatio: [0.0, 4.0],
        pitchDispersion: [0.0, 1.0],
        timeDispersion: [0.0, 1.0],
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
