(
var desc = "A simple high pass filter",
    func = {|numChannels|
        {|in, freq=100|
            var lagTime = \lagTime.kr(1);
            HPF.ar(in, freq.klag(lagTime))
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
