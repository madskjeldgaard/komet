(
var desc = "A resonant filter bank",
    func = {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            var freqs = \freqs.kr([100,400,800,2500]);
            var amps = \amps.kr([1,0.5,0.25,0.85]);
            var rings = \rings.kr([0.5,0.5,0.5,0.5]);
            // var specArray = \specArray.kr([, nil, [1, 1, 1, 1]]);

            var output = Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var lagTime = \lagTime.kr(1);
                var spread = 1+(\spread.kr(0.1)*chanNum);

                DynKlank.ar(
                    specificationsArrayRef:`[freqs, amps, rings],
                    input:sig * 0.1,
                    freqscale: K_NC.kr("freqscale", 1).klag(lagTime) * spread,
                    freqoffset: K_NC.kr("freqoffset", 0).klag(lagTime),
                    decayscale: K_NC.kr("decayscale", 0.1).klag(lagTime)
                ) * 0.5
            });

            Klimit.ar(output)
        }
    },
    type = \fx,
    category = \channelized,
    basename = \klank,
    numChans = nil, // TODO: Not used
    specs = (
        freqscale: [0.001,4.0, \lin],
        decayscale: [0.001,4.0, \lin],
        freqoffset: [0.0,1.0, \lin],
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
