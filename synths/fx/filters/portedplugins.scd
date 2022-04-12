(
// VadimFilter
KometFXFactory.add(
    basename: \vadim,
    synthfunc: {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff, res, type;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                type = \type.ir(1);
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                res = \res.ar(0.1).klag(lagTime);

                VadimFilter.ar(input:sig, freq:cutoff, resonance:res, type:type);

            })
        }
    },
    type: \channelized,
    specs:(
        cutoff: Spec.specs[\freq],
        res: [0.0,1.0],
        type: [0,5]
    ),
);

// Korg 35
KometFXFactory.add(
    basename: \korg35,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;

                VAKorg35.ar(input:sig, freq:cutoff, res:\res.ar(0.1).klag(lagTime), overdrive:\overdrive.kr(0.1).klag(lagTime), type:\type.ir(0))
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
KometFXFactory.add(
    basename: \valadder,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                VALadder.ar(
                    input:sig,
                    freq:cutoff,
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
KometFXFactory.add(
    basename: \diodefilter,
    synthfunc: {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                VADiodeFilter.ar(
                    input:sig,
                    freq:cutoff,
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
KometFXFactory.add(
    basename: \vasem,
    synthfunc: {|numChannels|
        {|in|

            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                var cutoff;
                var spread = \spread.kr(0.1).klag(lagTime);
                spread = (1 + (chanNum/numChannels * spread));
                cutoff = \cutoff.ar(500).klag(lagTime) * spread;
                VASEM12.ar(input:sig, freq:cutoff, res:\res.ar(0.1).klag(lagTime), transition:\transition.kr(0))
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
