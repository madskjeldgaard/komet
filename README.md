# Komet
![komet](assets/komet.png) 

Komet is a SuperCollider/Faust sound system by Mads Kjeldgaard.

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
