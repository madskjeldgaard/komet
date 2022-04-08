(
KometFXFactory.addFX(
    basename: \comb,
    synthfunc: {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = \spread.kr(0.1);
                var lagTime = \lagTime.kr(1);

                CombC.ar(sig, \maxdelay.ir(1), \delaytime.ar(0.25).klag(lagTime) * (1+(chanNum/numChannels*spread)), \decaytime.ar(3).klag(lagTime));

            })
        }
    },
    type: \channelized,
    specs:(
        maxdelay: [0.01,100],
        delaytime: [0.001,10, \exp],
        decaytime: [0,10],
        spread: 0.1,
    ),
);
)
