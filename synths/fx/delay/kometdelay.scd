(
var desc = "A feedback delay",
    func = {|numChannels|
        {|in, delay(0.15), feedback(0.5), interpolation(10)|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = 1.0 + \spread.kr(0.1);
                var lagTime = \lagTime.kr(1);

                KometDelay.ar(
                    sig,delay.klag(lagTime) * spread, feedback.klag(lagTime), interpolation.klag(lagTime)
                );

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \kometdelay,
    numChans = nil, // TODO: Not used
    specs = (
        delay: ControlSpec( 0.01,5000, warp: \lin, default: 500),
        feedback: ControlSpec( 0.0,100.0, default: 50),
        interpolation: ControlSpec.new( 1,100, default: 10),
        spread: ControlSpec.new( 0.0, 1.0 ),
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
