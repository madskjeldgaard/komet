(
var numChansOut = 2,
desc = "A Stereo VST Plugin",
func = {|in, bypass=0|
    var sig = in;

    \VSTPlugin.asClass.perform(\ar,
        sig,
        numChansOut,
        bypass
    )
},
type = \fx,
category = \stereo, // FIXME: This isn't a channelized fx
basename = \vstpluginstereo,
numChans = nil, // TODO: Not used
specs = (
    bypass: [0.0,1.0],
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
