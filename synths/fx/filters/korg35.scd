(
var desc = "A virtual analog Korg 35 filter",
    func = {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;

                VAKorg35.ar(input:sig, freq:cutoff, res:\res.ar(0.1).klag(lagTime), overdrive:\overdrive.kr(0.1).klag(lagTime), type:\type.ir(0))
            })
        }
    } ,
    type = \fx,
    category = \channelized,
    basename = \korg35,
    numChans = nil, // TODO: Not used
    specs = (
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        overdrive: [0.0,1.0],
        type: [0,1]
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
