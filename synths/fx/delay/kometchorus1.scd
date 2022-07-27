(
var desc = "A chorus with a feedback delay with a lowpass filter and limiter in feedback path",
    func = {|numChannels|
        {|in, delay(6), delayFloor(1), feedback(10.0), filterAmount=0.01, q=3.0, chorusFreq=0.25|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = 1.0 + \spread.kr(0.1);
                var lagTime = \lagTime.kr(1.0);
                var numParallelDelays = 4;

                Array.fill(numParallelDelays, {|delayNum|

                    var noiseFreq = chorusFreq;
                    var delaytime = SinOsc.ar(
                        noiseFreq + Rand.new(0.0,0.001 * noiseFreq),
                        phase: delayNum.linlin(0, numParallelDelays-1, -2pi, 2pi)
                    ).range(
                        delayFloor,
                        delayFloor+delay.klag(lagTime) * spread
                    );

                    KometFilterDelayLPF.ar(
                        in0: sig,
                        delay: delaytime,
                        feedback: feedback.klag(lagTime),
                        interpolation: 1,
                        freq: (1.0-filterAmount).klag(lagTime),
                        q: q.klag(lagTime),
                    );
                }).sum / numParallelDelays;

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \kometchorus1,
    numChans = nil, // TODO: Not used
    specs = (
        filterAmount: ControlSpec( 0.0,1.0, warp: \lin, default: 0.5),
        chorusFreq: ControlSpec.new(
                minval: 0.0001, maxval: 100.0, warp: 'exp', step: 0.0, default: 0.25
            ),
        q: ControlSpec( 0.5,10.0, warp: \lin, default: 3.0),
        delay: ControlSpec( 0.01,100, warp: \lin, default: 6),
        feedback: ControlSpec( 0.0,100.0, default: 50),
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
