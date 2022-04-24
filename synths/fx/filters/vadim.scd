(
var desc = "A multi filter based on Vadim's books",
    func = {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff, res, type;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                type = \filtertype.ir(1);
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                res = \res.ar(0.1).klag(lagTime);

                VadimFilter.ar(input:sig, freq:cutoff, resonance:res, type:type);

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \vadim,
    numChans = nil, // TODO: Not used
    specs = (
        cutoff: Spec.specs[\freq],
        res: [0.0,1.0],
        filtertype: [0,5]
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
