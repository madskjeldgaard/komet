(
var desc = "A frequency shifter",
    func = {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));

                FreqShift.ar(in:sig, freq:\shiftfreq.ar(1).klag(lagTime) * spread, phase:\shiftphase.kr(0))

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \freqshift,
    numChans = nil, // TODO: Not used
    specs = (
        shiftfreq: Spec.specs[\widefreq],
        shiftphase: Spec.specs[\phase],
        spread: [0,1]
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
