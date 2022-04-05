# Komet
![komet](assets/komet.png) 

Komet is a SuperCollider/Faust sound system by Mads Kjeldgaard.

The motivation for making this library was to create a central place for my synths but also a unified interface to make sure that all synths are expected to respond to the same parameters in the same way (especially pertaining to timing, envelopes and filters etc.) to make it easier for me to focus on the composition work.

## Usage

```supercollider
// Build lib
~numChannels = 2; // For ambisonics orders use symbols ala \O1, \O2, etc...
K.new(~numChannels, rebuild: true);

// Play using custom \m event
(
Pbind(
    \type, \k,
    \base, \complex,
    \env, \adsr,
    // Sequence through filters
    \filter, Pseq([\ladder, \diode, \korg35], inf),

    \atk, 0.25,
    \dec, 0.5,
    \rel, 0.25,

    \dur, 4.0,
    \legato, 2,

    \modFreq, Pexprand(100.001,0.01),
    \fmMod, Pwhite(),
    \wavefold, Pwhite(),
    \timbreMod, Pwhite(),

    \degree, Pstep(Pwhite(-3,3,1),16,inf)+Pwhite(0,6),
    \fenvAmount, Pwhite(),
    \cutoff, Pwhite(1250,5500),
    \resonance, 0.6,

    \pan, Pwhite(-0.9,0.9),
    \autopan, 0.1,
    \panShape, 2,

    \amp, 0.01,
).play
)
```

## Settings
Some server settings need to be adjusted to allow for the extreme amount of synthdefs produced:

```
s.options.maxSynthDefs_(10000);
```

## Install


```supercollider
Quarks.install("https://codeberg.org/madskjeldgaard/komet")
```

This library makes use of a range of internal Faust plugins and external c++-plugins.

TODO: 
- Install packages on arch
- Install packages on macos
