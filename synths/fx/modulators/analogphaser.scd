(
K_FX.addFX(
    basename: \analogphaser,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                var r = Array.rand(4, 0.99, 1.0);

                \AnalogPhaser.asClass.perform(
                    \ar,
                    input: sig,
                    lfoinput: LFTri.ar(\lfoFreq.kr(0.5).klag(lagTime) * r[0], iphase: chanNum.linlin(0, numChannels - 1, 0.0, 4.0)),
                    skew: \skew.ar(0.0).klag(lagTime) * r[1],
                    feedback: \feedback.ar(0.9).klag(lagTime) * r[2],
                    modulation: \modulation.ar(0.1).klag(lagTime) * r[3],
                    stages: \stages.ir(50)
                )
            })
        }
    },
    type: \channelized,
    specs:(
        lfoFreq: [0.0000001, 5500.0, \exp],
        skew: [-1.0, 1.0],
        feedback: [0.0, 0.95],
        modulation: [0.0,1.0],
        stages: [1,50],
    ),
    check: { \AnalogPhaser.asClass.notNil }

);
)
