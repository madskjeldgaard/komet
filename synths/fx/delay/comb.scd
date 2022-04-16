(
var desc = "A simple, channelized comb filter",
    func = {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = \spread.kr(0.1);
                var lagTime = \lagTime.kr(1);

                CombC.ar(
                    sig,
                    \maxdelay.ir(1),
                    \delaytime.ar(0.25).klag(lagTime) * (1+(chanNum/numChannels*spread)),
                    \decaytime.ar(3).klag(lagTime)
                );

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \comb,
    numChans = nil, // TODO: Not used
    specs = (
        maxdelay: [0.01,100],
        delaytime: [0.001,10, \exp],
        decaytime: [0,10],
        spread: [0.0, 1.0],
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
