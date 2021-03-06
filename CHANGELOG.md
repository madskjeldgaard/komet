# Changelog
## [0.1.5] - 2022-07-19

### Bug Fixes

- Typo in name of \lockhart
- Faust files not picked up in extensions
- Lockhart specs wrongly named
- \hpf collapsed stereo to mono
- *clean not working
- Clear kometchain after free
- Clear before setting chain
- Make channels optional in AbstractKometChain
- Chain shouldn't build library
- HOA synthffuncdefs not purged in non-hoa mode
- Chain gui sometimes had wrong indices when adding/removing
- Main chain not set if config empty

### Documentation

- Add info about action

### Features

- Add config file
- Add basic VST fx plugin support
- Add vst gui to chain gui
- Add KometSynthFuncDef*allOfCategory
- Add *postInit to extension
- Add freeverb synth
- Add Madstorro reverb
- Add KometDelay
- Add SafetyLimiter and add it to default chain

## [0.1.4] - 2022-07-10

### Bug Fixes

- Simplify ~base in event
- Komet.build not passing KometChannels on
- Move VSTPlugin stuff to a seperate package
- Drywet full by default
- FX don't have default args from parent wrap
- Only load (hoa) resources when necessary
- Chain, free/init nodetree when adding/removing
- Free before adding fx to chain
- Change window defaults to include border
- Make lagTime 0 by default in event and other defaults
- Autopan not working in HOA (Because of wrong name)
- *browse not working
- Values lagging to initial value
- Complex, only add timbreMod if wavefolder
- Report when boot process done
- Komet Chains trying to add before server booted
- Specs contained wrong defaults
- Default record path not absolute
- Komet*start possible to be called twice
- Use Plugins.quark for non-Arch systems
- Quote path properly
- Use CondVar when checking chains
- Wait is needed in KometMainChain test
- KometSynthLib test adding before fxlib init
- KometEvents test not working (because of not waiting)

### Documentation

- Add more examples
- Add docs for Komet
- Beef up KometIntro
- Add install info

### Features

- Add ambisonics mode. Only load HOA stuff if in that.
- Fix up GUI to make it nicer
- Add callback after Komet.start
- Warn if server not booted
- Set default log level to debug
- Add HOA info to filename if recording in hoa
- Add formant, vosim and zosc synths
- Add pluck and rongs synths
- Add warning about num inputs messing up mic
- Add silence and input synths
- Add PtparToggle pattern class
- Add Komet*resourcePath (for presets)
- Add *playSoundfile to Komet
- Add plugins.quark as dependency
- Use plugins.quark to install dependencies
- Add external plugin dependencies to quark
- Add musliplayer synth

## [0.1.3] - 2022-06-28

### Bug Fixes

- Make browse work again
- Set eq specs properly
- Set fxChain to new chain when setting new

### Features

- Add *record to Komet
- Add KometChannels to add type safety
- Add leakdc to default main chain
- Make it possible to add fx to chain in GUI
- Add Komet.gui - main interface
- Add (ugly) themeing to gui
- Add *record and *stopRecording

### Faet

- Add gui to chain classes

## [0.1.2] - 2022-04-26

### Bug Fixes

- Rename
- .klag typo
- DRY file loading
- Standardize KometPath paths
- Download submodule if necessary
- Check more consistently for ambisonic order inputs
- ..klag typo
- Typo
- Use Faust-LinkwitzRiley crossover filters
- Stop file loading if an error occurred
- ~sustain in default event causing to loud sounds
- Curve name in event not the same as in envelope
- Change autopan yet again. It better goddamn work this time
- Erronous args could lead to server crash
- Proper spread in freqshift
- Better error management in KometMainChain
- Update \k event to reflect new paradigm
- Typos
- Make chains work with new paradigm
- Synthargs not used on init
- Change outputugen , fade and drywet
- Make all envelope args lowercase
- Set initialized var when not building

### Documentation

- Add help files for undocumented classes
- Add some muthafucking help files

### Features

- Add faust files
- Add all basic stuff from mk-synthlib and mk-fxlib
- Install dependencies the smart way: KometDependencies
- Add parallel
- Add Log as dependency
- Add macos build scripts
- Replace SafetyLimiter with faust based limiter
- Add dependency checker
- Add KometNvim for basic neovim access
- Add FZFdef
- Make Komet the central class
- Add KometEvents and KometSpecs
- Add support for mainfx using KometMain
- Add KometMainChain: Global fx chains
- Add auto help file generator
- Add \spread to all portedplugin filters
- Add \vadim filter
- Add *clean and *uninstall
- Add klimit synth
- Refactor chain system and add event type
- Load test buffers at server boot
- Add ugen extensions for wow and pitchenv
- Add complex
- Add -psetAt argument to chain
- Add limiter to main output
- Add \hpf
- Add VST plugin support
- Update chain fx pattern control

### Refactor

- Rename K to KometSynthFactory
- Move loadSourceFunctions...
- Change *addFX to *add and *addDef to *prAddDef
- Rename KLoad to KometComponentLoader and test
- EVERYTHING pt1: Cleaner class separation

### Testing

- Test if all faust files compile
- Add basic test framework and add to update process
- Chain
- KometEvents
- Faust files

<!-- generated by git-cliff -->
