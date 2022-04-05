/*****************************************
* FLUTE
*****************************************/
(
Pdef(\flute,
    Pbind(\type,
        \m,
        \base, \floejte,
        \env, \gate,
        \filter, \none,

        \octave, 3,
        \degree, Pwhite(0,5),

        \vibratofreq, Pwhite(0.01,100.0),
        \vibratogain, Pwhite(),

        \mouthposition, Pwhite(0.2,0.6),

        \dur, 8,
        \legato, 2,
        \pan, 0.25 * Pseq([-1.0, 1.0], inf)
    )
).play
)
