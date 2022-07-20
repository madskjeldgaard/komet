(
var desc = "Channelized FreeVerb",
    func = {|numChannels|
        {|in, room=0.5, damp=0.01|
            var lagTime = \lagTime.kr(1);

            Array.fill(numChannels, {|chanNum|
                var sig = in[chanNum];

                FreeVerb.ar(in:sig, mix:1, room:room, damp:damp)

            })
        }
    },
    type = \fx,
    category = \channelized,
    basename = \freeverb,
    numChans = nil, // TODO: Not used
    specs = (
        room: [0.0, 1.0],
        damp: [0.0, 1.0],
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
