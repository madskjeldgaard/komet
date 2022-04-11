(
KometFXFactory.add(
    basename: \eq3,
    synthfunc: {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var lagTime = \lagTime.kr(1);
                Ekvi3.ar(sig,
                    \bw1.kr(100).lag(lagTime),
                    \bw2.kr(100).lag(lagTime),
                    \bw3.kr(100).lag(lagTime),
                    \belllevel1.kr(0).lag(lagTime),
                    \belllevel2.kr(0).lag(lagTime),
                    \belllevel3.kr(0).lag(lagTime),
                    \bellfreq1.kr(1000).lag(lagTime),
                    \bellfreq2.kr(1500).lag(lagTime),
                    \bellfreq3.kr(2000).lag(lagTime),
                    \highfreq.kr(8000).lag(lagTime),
                    \highlevel.kr(0).lag(lagTime),
                    \lowfreq.kr(8000).lag(lagTime),
                    \lowlevel.kr(0).lag(lagTime)
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
