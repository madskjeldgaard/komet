(
K_FX.addFX(
    basename: \analogvintagedistortion,
    synthfunc: {|numChannels|
        {|in|
            var lagTime = \lagTime.kr(1);
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                \AnalogVintageDistortion.asClass.perform(
                    \ar,
                    input:sig,
                    drivegain:\drivegain.kr(0.5)..klag(lagTime),
                    bias:\drivebias.kr(0.0)..klag(lagTime),
                    lowgain:\lowgain.kr(-10).dbamp..klag(lagTime),
                    highgain:\highgain.kr(-10).dbamp..klag(lagTime),
                    shelvingfreq:\shelvingfreq.kr(1500)..klag(lagTime),
                    oversample:\oversample.ir(1)
                )
            })
        }
    },
    type: \channelized,
    specs:(
        drivegain: [0.0, 1.0],
        bias: [0.0, 2.5],
        lowgain: Spec.specs[\db],
        highgain: Spec.specs[\db],
        shelvingfreq: Spec.specs[\freq],
        oversample: [0,4]
    ),
    check: { \AnalogVintageDistortion.asClass.notNil }

);
)
