# Komet
![komet](assets/komet.png) 

Komet is a computer music / sound system by Mads Kjeldgaard written in [supercollider](https://github.com/supercollider/supercollider) and [faust](https://faust.grame.fr/).

It is currently not intended for use by others, but feel free to check it out.

## About the system

Komet is a library and a factory. 

### Features

Komet is a computer music system that makes advanced synthesis operations and composition easier. It auto generates thousands of synthesizer variations from simple recipes and offers a range of DAW-like features such as effect chains (like on channel strips) and other conveniences. It can work natively in stereo, multichannel or high order ambisonics mode with the flick of a switch, allowing the same compositions to be used in different sound systems.

The main principle is to modularize the synth components into simple source functions and components that are then combined in all sorts of combinations. This way, a sound process only needs to be defined once to be built using all combinations of those components. This leads to more predictable naming schemes that makes it easier to compose with.

In addition, the system contains many convenience functions, custom types and shortcuts to help avoid common mistakes when composing with SynthDefs in patterns in SuperCollider. As an example - a piece of music can be written using this package for a stereo setup, but then if you want to work on it in high order ambisonics, you simply change the number of channels in the setup. The arguments of the SynthDefs produced are predictable (and aliased in the custom event types) to avoid embarrassing mistakes like setting the `\atk` of a Synth in a pattern when in fact it was defined with the name `\attack`, instead of hard coding this in a bunch of SynthDefs (leading to errors and discrepancies), you only need to define this once and it is propagated into all the SynthDefs produced. 

- Define one source sound function, get a plethora of SynthDefs - each source function is combined with every envelope, filter and panning function in the library automatically.
- Consistent argument names in SynthDefs
- Strict typing to ensure data is initialized correctly
- An FX library organized into stereo, channelized and high order ambisonics versions.
	- Includes a framework for generating "parallel processing" fx SynthDefs from all defined fx source functions
- Multichannel support:
	- Azimuth-based multichannel panning
	- High order ambisonics
	- Stereo output
	- Mono output
- Shipped with custom Faust plugins that are automatically compiled and installed.
- JITlib-style FX chain as well as a "main output" effect system
- Event types to make it easier and less errorprone to write patterns
- Pattern types to easily manipulate fx chains or the main output effects
- An expansive library of custom Faust-based plugins including filters, equalizers, compressors etc.

## Dependencies

- Faust => v2.40
- SuperCollider => v3.12
- sc3-plugins => v3.12

## Install

```supercollider
Quarks.install("https://codeberg.org/madskjeldgaard/komet")
```

This library makes use of a range of internal Faust plugins and external c++-plugins.

### External plugins

#### Faust plugins

Faust plugins are automatically compiled and installed after the first class library compilation after the system has detected the correct faust version (specifically it looks for the `faust2sc.py` executable). These plugins are installed in their own folder in Extensions.

If they're not installed, you can force the installation by running `KometDependencies.installFaustPlugins()`.

#### C++ plugins
Some external plugins written in C++ are necessary as well.

These are:
- [vstplugin](https://git.iem.at/pd/vstplugin)
- [xplaybuf](https://github.com/elgiano/XPlayBuf) 
- [guttersynth-sc](https://github.com/madskjeldgaard/guttersynth-sc)
- [squinewave](https://github.com/required-field/squinewave)
- [portedplugins](https://github.com/madskjeldgaard/portedplugins)

You can either install them yourself or run `KometDependencies.installPlugins()`.

### Necessary server settings
Some server settings need to be adjusted to allow for the extreme amount of synthdefs produced:

```
s.options.maxSynthDefs_(10000);
```

## Thanks

Some parts of the system's dsp library are inspired or lifted from others' open source projects. Their code falls under their own licenses. 

Here are (some) of the people I'd like to thank:

- Julian Rohrhuber, Alex McLean and other developers of [SuperDirt](https://github.com/musikinformatik/SuperDirt)
- Jean-Louis Paquelin
- Nathan Ho
- Alejandro Olarte
- Alik Rustamoff aka. Reflectives
- Scott Carver
