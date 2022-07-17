(
var desc = "Channelized (mono) Datorro style reverb",
    func = {|numChannels|
        {|in,damping(0.625), decaydiffusion1(0.625), decaydiffusion2(0.625), decayrate(0.7), inputdiffusion1(0.625), inputdiffusion2(0.625), prefilter(0.7)|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                Madstorro.ar(sig,damping, decaydiffusion1, decaydiffusion2, decayrate, inputdiffusion1, inputdiffusion2, prefilter)
            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \madstorro,
    numChans = nil, // TODO: Not used
    specs = (
        damping: ControlSpec.new( 0.0, 1.0, default: 0.625),
        decayrate: ControlSpec.new( 0.0, 1.0, default: 0.7 ),
        decaydiffusion1: ControlSpec.new( 0.0, 1.0, default: 0.625),
        decaydiffusion2: ControlSpec.new( 0.0, 1.0, default: 0.625),
        inputdiffusion1: ControlSpec.new( 0.0, 1.0 ),
        inputdiffusion2: ControlSpec.new( 0.0, 1.0 ),
        prefilter: ControlSpec.new( 0.0, 1.0 ),
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
