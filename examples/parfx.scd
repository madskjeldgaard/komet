K_FX.new(2);

(
var releaseTime = 1;

Pdef(\,
    MParFXShared(
        Pbind(
            \octave, Pwhite(3,5),
            \degree, Plet.new(\deggy, pattern: Pwhite(0,10)),
            \dur, Pwrand([Pwhite(0.1,1.0,1)*Rest(), 0.25], [0.25, 0.75], inf),
            \amp, Pwhite(0.125,0.25),
            \pan, Pwhite(-1.0,1.0)
        ),
        K_FX.get(basename:\comb, type:\channelized),
        [
            \delaytime, Ptrace(Pget(\deggy, 1, inf) + 1 / 30 + 0.1).trace(prefix:"delaytime: "),
            \drywet, 0.25,
            \dur, Pwhite(1.0,4.0),
            \lagTime, Pkey(\dur),
            \maxdelay, 4,
            \decaytime, 12,
            \gate, 1,
            \fadeOutTime, releaseTime
        ],
        releaseTime: releaseTime,
    ),
).play;
)

Pdef(\).stop;
