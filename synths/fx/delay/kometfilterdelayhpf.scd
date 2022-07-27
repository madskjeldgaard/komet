(
var desc = "A feedback delay with a highpass filter and limiter in feedback path",
    func = {|numChannels|
        {|in, delay(0.15), feedback(0.5), interpolation(10), filterAmount=0.5, q=3.0|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = 1.0 + \spread.kr(0.1);
                var lagTime = \lagTime.kr(1);

                KometFilterDelayHPF.ar(
                    in0: sig,
                    delay: delay.klag(lagTime) * spread,
                    feedback: feedback.klag(lagTime),
                    interpolation: interpolation.klag(lagTime),
                    freq: (1.0-filterAmount).klag(lagTime),
                    q: q.klag(lagTime),
                );

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \kometfilterdelayhpf,
    numChans = nil, // TODO: Not used
    specs = (
        filterAmount: ControlSpec( 0.0,1.0, warp: \lin, default: 0.5),
        q: ControlSpec( 0.5,10.0, warp: \lin, default: 3.0),
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
