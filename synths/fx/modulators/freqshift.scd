(
KometFXFactory.add(
    basename: \freqshift,
    synthfunc: {|numChannels|
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
    type: \channelized,
    specs:(
        shiftfreq: Spec.specs[\widefreq],
        shiftphase: Spec.specs[\phase],
        spread: [0,1]
    ),
);
)
