KometSynthFactory : AbstractKometFactory {
  classvar
  <kometChannels,
  <synthFuncs,
  <initialized = false,
  <forceRebuild=false;

  *new {|numChannelsOut=2, rebuild=false|
    ^this.init(numChannelsOut, rebuild);
  }

  *init{|numChannels, rebuild|
    forceRebuild=rebuild;
    if(numChannels.isKometChannel, {
        if(numChannels.check(), {
            kometChannels = numChannels;
            if(KometComponentLoader.allLoaded.not, {
                KometComponentLoader.loadAll();
            });

            if(forceRebuild.not, {
                "Not rebuilding %. Reading defaults from SynthDescLib.".format(this.name).warn;
                SynthDescLib.read();
                initialized = true;
            }, {
                initialized = this.loadSourceFunctions(KometSynthLib.files[\synths]);
            });
        });
    }, {
        Log(\komet).error("%: Not a valid KometChannel".format(this.class.name));
    });

  }

  // TODO: This should just return the built functions etc and not load and put it in synthlib. Too many side effects
  *prAddSynthDef{|kometSynthFuncDef|
      if(KometComponentLoader.allLoaded, {
          KEnvelopes().keys.do{|envType|
              KFilters().keys.do{|filterType|
                  // Only load HOA things in HOA mode
                  if(kometSynthFuncDef.category == \hoa && kometChannels.isAmbisonics.not, {
                      // Skip if Komet is not in HOA mode and the synthdef is a hoa one
                      Log(\komet).debug("Skipping kometSynthFuncDef % because Komet is not in HOA mode and it is a HOA synth", kometSynthFuncDef.name);
                  }, {
                  var synthdefname = kometSynthFuncDef.synthdefName(envType, filterType);

                  // No VCA and no Out-UGen (makes it useful in Ndefs)
                  var rawFunc = { | dur=1, amp=0.25|

                      // Get source function
                      var sig = SynthDef.wrap(kometSynthFuncDef.func, prependArgs: [ dur ]);

                      sig = KFilters().getWrap(filterType, "f", "", envType, sig, dur, 0);

                      sig = KPanners().getWrap(kometSynthFuncDef.channels, kometChannels, "", "", sig);

                      sig * amp
                  };

                  // SynthDef version
                  var builtFunc = {|out=0, envDone=2, dur=1|

                      var sig = SynthDef.wrap(rawFunc, prependArgs: [ dur ]);

                      // Apply VCA envelope
                      sig = sig * KEnvelopes().getWrap(envType, "vca", "", dur, envDone);

                      Out.ar(out, sig);
                  };
                  var synthdef = SynthDef.new(synthdefname,builtFunc);

                  // Add to global synthlib
                  var type = kometSynthFuncDef.type;
                  var category = kometSynthFuncDef.category;
                  var baseName = kometSynthFuncDef.name;
                  KometSynthLib.put(type, category, envType, filterType, baseName, \rawFunc, rawFunc);
                  KometSynthLib.put(type, category, envType, filterType, baseName, \builtFunc, builtFunc);
                  KometSynthLib.put(type, category, envType, filterType, baseName, \synthDefName, synthdefname);
                  KometSynthLib.put(type, category, envType, filterType, baseName, \synthDef, synthdef);
                  KometSynthLib.put(type, category, envType, filterType, baseName, \kometSynthFuncDef, kometSynthFuncDef);

                  Log(\komet).info("Added SynthDef % and loading it now", synthdefname);

                  // Save to disk and load the synthdef
                  synthdef.load;

                  })
              }
          }
      }, {
          Log(\komet).error("Components not loaded");
      })
  }

}
