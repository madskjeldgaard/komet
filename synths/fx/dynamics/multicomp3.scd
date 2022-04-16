(
var desc = "A 3 band multiband compressor",
    func = {|numChannels|
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
    type = \fx,
    category = \channelized,
    basename = \multicomp3,
    numChans = nil, // TODO: Not used
    specs = (
        attack1: [0.0,10.0,\exp],
        attack2: [0.0,10.0,\exp],
        attack3: [0.0,10.0,\exp],
        crossoverfreq1: Spec.specs[\freq],
        crossoverfreq2: Spec.specs[\freq],
        makeup1: [-96,96,\lin],
        makeup2: [-96,96,\lin],
        makeup3: [-96,96,\lin],
        ratio1: [1.0,40.0],
        ratio2: [1.0,40.0],
        ratio3: [1.0,40.0],
        release1: [0.0,10.0,\exp],
        release2: [0.0,10.0,\exp],
        release3: [0.0,10.0,\exp],
        thresh1: Spec.specs[\db],
        thresh2: Spec.specs[\db],
        thresh3: Spec.specs[\db],
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
