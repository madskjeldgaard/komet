(
var desc = "A Vasem filter. This filter has the specialty of being able to shift between a lowpass and a highpass filter, with a notch-filter in between.",
    func = {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                VASEM12.ar(input:sig, freq:cutoff, res:\res.ar(0.1).klag(lagTime), transition:\transition.kr(0))
            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \vasem,
    numChans = nil, // TODO: Not used
    specs = (
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        transition: [0.0, 1.0]
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
