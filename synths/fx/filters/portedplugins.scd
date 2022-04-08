(
// Korg 35
K_FX.addFX(
    basename: \korg35,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                VAKorg35.ar(input:sig, freq:\cutoff.ar(500).klag(lagTime), res:\res.ar(0.1).klag(lagTime), overdrive:\overdrive.kr(0.1).klag(lagTime), type:\type.ir(0))
            })
        }
    },
    type: \channelized,
    specs:(
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        overdrive: [0.0,1.0],
        type: [0,1]
    ),
);

// VALadder
K_FX.addFX(
    basename: \valadder,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                VALadder.ar(
                    input:sig,
                    freq:\cutoff.ar(500).klag(lagTime),
                    res:\res.ar(0.1).klag(lagTime),
                    overdrive:\overdrive.kr(0.1).klag(lagTime),
                    type:\type.ir(0)
                )
            })
        }
    },
    type: \channelized,
    specs:(
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        overdrive: [0.0,1.0],
        type: [0,5]
    ),
);

// VADiodeFilter
K_FX.addFX(
    basename: \diodefilter,
    synthfunc: {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                VADiodeFilter.ar(
                    input:sig,
                    freq:\cutoff.ar(500).klag(lagTime),
                    res:\res.ar(0.1).klag(lagTime),
                    overdrive:\overdrive.kr(0.1)
                )
            })
        }
    },
    type: \channelized,
    specs:(
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        overdrive: [0.0,1.0],
        type: [0,1]
    ),
);

// vasem
K_FX.addFX(
    basename: \vasem,
    synthfunc: {|numChannels|
        {|in|

        var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                VASEM12.ar(input:sig, freq:\cutoff.ar(500).klag(lagTime), res:\res.ar(0.1).klag(lagTime), transition:\transition.kr(0))
            })
        }
    },
    type: \channelized,
    specs:(
        cutoff: Spec.specs[\freq],
        res: [0.0,1.96],
        transition: [0.0, 1.0]
    ),
);
)
