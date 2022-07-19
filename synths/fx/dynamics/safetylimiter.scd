(
var desc = "An Nathan's SafetyLimiter",
    func = {|numChannels|
        {|in, releaseTime=0.5, holdTime=0.1|

            SafetyLimiter.ar(input:in, releaseTime:releaseTime, holdTime:holdTime);

        }
    },
    type = \fx,
    category = \channelized,
    basename = \safetylimiter,
    numChans = nil, // TODO: Not used
    specs = (

        holdTime: ControlSpec.new(minval:0.0000001, maxval:10.0, warp:\lin, step:0.0, default:0.1, units:nil, grid:nil),
        releaseTime: ControlSpec.new(minval:0.0000001, maxval:10.0, warp:\lin, step:0.0, default:0.5, units:nil, grid:nil);
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
