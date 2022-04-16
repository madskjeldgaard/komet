(
var desc = "A linkwitz-riley based 2 band splitter",
    func = {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                Krossover2.ar(
                    sig,
                    \freq.kr(1000).klag(lagTime)
                )
            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \split2,
    numChans = nil, // TODO: Not used
    specs = (
        freq: Spec.specs[\freq],
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

desc = "A linkwitz-riley based 4 band splitter";
func = {|numChannels|
    {|in|

        var lagTime = \lagTime.kr(1);
        Array.fill(numChannels, {|chanNum|
            var sig = in[chanNum];
            Krossover4.ar(
                sig,
                \freq1.kr(100).klag(lagTime),
                \freq2.kr(1000).klag(lagTime),
                \freq3.kr(10000).klag(lagTime),
            )
        })
    }
};
type = \fx;
category = \channelized;
basename = \split4;
numChans = nil; // TODO: Not used
specs = (
    freq1: Spec.specs[\freq],
    freq2: Spec.specs[\freq],
    freq3: Spec.specs[\freq],
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
