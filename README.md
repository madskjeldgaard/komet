# Komet
![komet](assets/komet.png) 

Komet is a computer music / sound system by Mads Kjeldgaard written in [supercollider](https://github.com/supercollider/supercollider) and [faust](https://faust.grame.fr/).

It is currently not intended for use by others, but feel free to check it out.

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

## Thanks

Some parts of the system's dsp library are inspired or lifted from others' open source projects. Their code falls under their own licenses. 

Here are (some) of the people I'd like to thank:

- Jean-Louis Paquelin
- Nathan Ho
- Alejandro Olarte
- Alik Rustamoff aka. Reflectives
- Scott Carver
