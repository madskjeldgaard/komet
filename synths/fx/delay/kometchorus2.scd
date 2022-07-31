(
var desc = "A simple chorus with a comb filter",
    func = {|numChannels|
        {|in, delay(0.006), delayFloor(0.001), maxdelaytime=1.0, decaytime=0.001, chorusFreq=0.25|
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

                    CombC.ar(
                        sig,
                        maxdelaytime,
                        delaytime,
                        decaytime
                    );

                }).sum / numParallelDelays;

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \kometchorus2,
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
