(
var desc = "A simple high pass filter",
    func = {|numChannels|
        {|in, freq=100|

            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                HPF.ar(sig, freq.klag(lagTime))
            });

        }
    },
    type = \fx,
    category = \channelized,
    basename = \hpf,
    numChans = nil, // TODO: Not used
    specs = ();

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
