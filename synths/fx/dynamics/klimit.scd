(
var desc = "A faust based limiter",
    func = {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var lagTime = \lagTime.kr(1);

                Klimit.ar(in0:sig,
                    attack:K_NC.kr(\attack, 0.001).klag(lagTime),
                    ceiling:K_NC.kr(\ceiling, 0.95).klag(lagTime),
                    hold:K_NC.kr(\hold, 0.1).klag(lagTime),
                    release:K_NC.kr(\release, 0.5).klag(lagTime)
                );

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \klimit,
    numChans = nil, // TODO: Not used
    specs = (
        attack:[0.00000001,2],
        ceiling:[0.00001,1],
        hold:[0.00000001,3],
        release:[0.00000001,2],
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
