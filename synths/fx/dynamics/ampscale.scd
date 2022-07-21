(
var desc = "Literally just an amplitude scale",
    func = {|numChannels|
        {|in, ampScale=1|
            in * ampScale.poll
        }
    },
    type = \fx,
    category = \channelized,
    basename = \ampscale,
    numChans = nil, // TODO: Not used
    specs = (ampScale: Spec.specs[\amp]);

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
