// TODO
(
KometFXFactory.add(
    basename: \multicomp3,
    synthfunc: {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var lagTime = \lagTime.kr(1);
                Multikomp3.ar(sig,
                    \attack1.kr(0.001),
                    \attack2.kr(0.001),
                    \attack3.kr(0.001),
                    \crossoverfreq1.kr(500),
                    \crossoverfreq2.kr(2500),
                    \makeup1.kr(0),
                    \makeup2.kr(0),
                    \makeup3.kr(0),
                    \ratio1.kr(4),
                    \ratio2.kr(4),
                    \ratio3.kr(4),
                    \release1.kr(0.01),
                    \release2.kr(0.01),
                    \release3.kr(0.01),
                    \thresh1.kr(-10),
                    \thresh2.kr(-10),
                    \thresh3.kr(-10),
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
