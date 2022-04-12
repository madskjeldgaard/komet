(
KometFXFactory.add(
    basename: \klimit,
    synthfunc: {|numChannels|
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
    type: \channelized,
    //TODO
    specs:(
        // maxdelay: [0.01,100],
        // delaytime: [0.001,10, \exp],
        // decaytime: [0,10],
        // spread: 0.1,
    ),
);
)
