(
var desc = "A DC filter",
    func = {|numChannels|
        {|in, coef=0.995|
            LeakDC.ar(in, coef)
        }
    },
    type = \fx,
    category = \channelized,
    basename = \leakdc,
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
