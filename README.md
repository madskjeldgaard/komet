# Komet
![komet](assets/komet.png) 

Komet is a computer music / sound system by Mads Kjeldgaard written in [supercollider](https://github.com/supercollider/supercollider) and [faust](https://faust.grame.fr/).

It is currently not intended for use by others, but feel free to check it out.

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
