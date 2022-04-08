(
KometFXFactory.addFX(
    basename: \timemachine,
    synthfunc: {|numChannels|
            {|in, offset=0, reclvl=0.5, prelvl=0.5, timerate=2.0, fb=0.25, record=1, jumpToStart=1, damp=0.25|

                var lagTime = \lagTime.kr(1);

                var tapeLengthInSeconds = \tapeLength.ir(4);
                var samples = SampleRate.ir * tapeLengthInSeconds;
                var local = LocalBuf(samples, numChannels: numChannels).clear;
                var sig;
                var feedback = LocalIn.ar(fb * in, numChannels: numChannels).tanh;

                RecordBuf.ar(in + feedback, local, offset * samples, reclvl, prelvl,  run: record,  loop: 1.0,  trigger: jumpToStart,  doneAction: 0);

                sig = PlayBuf.ar(numChannels, local, timerate.lag(lagTime), 1.0, 0.0, 1.0, doneAction: 0);
                sig = LeakDC.ar(sig);

                LocalOut.ar(LPF.ar(sig, damp.linexp(0.000000001,1.0,20000.0,250.0).lag(lagTime)));

                sig
            }
    },
    type: \channelized, // channelized, stereo or ambisonic
    specs: (
        tapeLength: [0.1,1000],
        offset: [0.0, 1.0],
        reclvl: [0.0, 1.0],
        prelvl: [0.0, 1.0],
        timerate: [-10.0, 10.0],
        fb: [0.0, 1.0],
        record: [0.0, 1.0],
        jumpToStart: [0.0, 1.0],
        damp: [0.0, 1.0]
    )
);
)
