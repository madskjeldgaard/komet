(
var buffer_duration = 10;
var desc = "A granular synth inspired by MI Beads",
    func = {|numChannels|
        {|in|
            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];
                // FIXME: This is wrong
                var spread = \spread.kr(0.1);
                var lagTime = \lagTime.kr(1);
                var reverse = K_NC.kr(\reverse, 0);

                // TODO: Lag
                Musli.ar(
                    in0:sig,
                    freeze:K_NC.kr(\freeze, 0),
                    seed:K_NC.kr(\seed, 0),
                    density:K_NC.kr(\density, 1),
                    feedback:K_NC.kr(\feedback, 0),
                    inputgain:K_NC.kr(\inputgain, 0),
                    outputgain:K_NC.kr(\outputgain, 0),
                    pitch:K_NC.kr(\pitch, 0),
                    reverse:reverse,
                    shape:K_NC.kr(\shape, 0),
                    size:K_NC.kr(\size, 0.5) * (1+(spread)),
                    time:K_NC.kr(\time, 0)* (1+(spread))
                );

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \musli,
    numChans = nil, // TODO: Not used
    specs = (
        freeze: [0,1],
        seed: [0,1],
        density: [0.01,10.0, \exp],
        feedback: [0.0,1.0],
        inputgain: Spec.specs[\db],
        outputgain: Spec.specs[\db],
        pitch: [-24.0,24.0],
        reverse: [0,1],
        shape: [0.0,1.0],
        size: [0.0, buffer_duration,\exp],
        time: [0.0,1.0],
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
