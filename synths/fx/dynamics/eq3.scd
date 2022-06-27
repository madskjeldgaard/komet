(
var desc = "An equalizer with low- and highshelf + 3 bell curves",
    func = {|numChannels|
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
    type = \fx,
    category = \channelized,
    basename = \eq3,
    numChans = nil, // TODO: Not used
    specs = (
        bw1: Spec.specs[\freq],
        bw2: Spec.specs[\freq],
        bw3: Spec.specs[\freq],
        bellfreq1: Spec.specs[\freq],
        bellfreq2: Spec.specs[\freq],
        bellfreq3: Spec.specs[\freq],
        highfreq: Spec.specs[\freq],
        lowfreq: Spec.specs[\freq],
        belllevel1: [-96, 96, \lin, 0].asSpec,
        belllevel2: [-96, 96, \lin, 0].asSpec,
        belllevel3: [-96, 96, \lin, 0].asSpec,
        highlevel: [-96, 96, \lin, 0].asSpec,
        lowlevel: [-96, 96, \lin, 0].asSpec,
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
