KometFXFactory.installFaustPlugins()

b = Buffer.read(s, "~/testsound/whistle.wav".asAbsolutePath)

(
Ndef(\musli,{|freeze(0), seed(0), density(1), feedback(0), inputgain(0), outputgain(0), pitch(0), shape(0.5), reverse(0), size(0.5), time(0)|

    var in0 = PlayBuf.ar(numChannels:2, bufnum:b, rate:1.0, trigger:1.0, startPos:0.0, loop:1.0, doneAction:0).sum;
    in0 = Musli.ar(in0,freeze, seed, density, feedback, inputgain, outputgain, pitch,  reverse,shape, size, time) * 0.5;

    in0!2 + (Andromeda.ar(in0, in0, decay: 3.5, mod: 1) * 0.5) * 0.5;
    // in0!2 + Datorroplusplus.ar(in0, in0, bandwidth: 0.1, decay: 0.9) * 0.125;
    // (in0 + (JPverb.ar(in:in0, t60:1.0, damp:0.0, size:1.0, earlyDiff:0.707, modDepth:0.1, modFreq:2.0, low:1.0, mid:1.0, high:1.0, lowcut:500.0, highcut:2000.0)*0.25)) / 2;
}).play
)

Ndef(\musli).set(\density, 34, \size, 0.05, \pitch, (-1), \reverse, 1, \shape, 0.4, \time, 0.85, \feedback, 0.35)

s.meter;
