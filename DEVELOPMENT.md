# General

Development happens on the `develop` branch. Once it has stabilized and there are enough features, it might be time for an update. See below. 

## Updating
Updating implies setting a new git tag and generating a changelog using `git cliff` (see [here for more information](https://github.com/orhun/git-cliff) ). This is handled automatically by the `update` script in the [scripts](../scripts/) folder.

The script will not allow an update if the test suite for this package does not pass.

## Testing

All tests may be run by running:

`sclang scripts/runtests.scd`

Note: This will automatically be invoked when running the update script.

### Adding synths

**specs:**
- First argument must always be `dur`
- Pitched source sounds: 
	- Implement a pitch envelope.
	- add freqOffset or pitchOffset or rateOffset parameter
- lag on all relevant params

### Adding effects

**specs:**
- All appropriate arguments must be suffixed with `.klag(lagTime)` where `lagtime = K_NC.kr(\lagTime, 1)`. This is to allow forcing a smooth transition in situations where it isn't normally possible.

#### Channelized

Channelized effects are essentially single channel effects applied to all channels of a multichannel signal.

**specs:**
- When appropriate, add an argument for `spread` allowing to distribute certain parameters over channels. Typically this parameter would scale another parameter depending on what channel it is. Eg: `var spread = K_NC.kr(\spread, 0.1).klag(lagTime); spread = (1 + (chanNum/numChannels * spread));`
                
