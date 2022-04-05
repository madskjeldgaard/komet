K {
  classvar verbosity,
  <numChansOut,
  <synths,
  <synthFuncs,
  <synthNames, // Flat list of synth names
  <path, <files, <faustFiles,
  <initialized = false,
  <forceRebuild,
  <faustInstaller,
  <pkgName = 'komet';

  *new {|numChannelsOut=2, rebuild=false, verbose=true|
    ^this.init(numChannelsOut, rebuild, verbose);
  }

  *initClass{
      StartUp.add({
          path = PathName(Main.packages.asDict.at(pkgName));
          files = (path +/+ "synths").folders.collect{|dir| dir.files}.flatten;
          faustFiles =(path +/+ "faust").files.select{|ff| ff.extension == "dsp"};
          synthNames = [];
          synthFuncs = IdentityDictionary.new;
          synths = IdentityDictionary.new;
      });

      StartUp.add({
            // This will trigger compilation if it hasn't already been compiled
            faustInstaller = K_FaustInstaller.new(
                // Will be compiled to extensions/...
                "KSynthLibFaustPlugins",
                // Source of faust files
                sourcecodeDir: path +/+ "faust",
                // Trigger autocompile if folder does not exist
                autoCompile: true
            );
        })
  }

  *init{|numChannels, rebuild, verbose|
    forceRebuild=rebuild;

    numChansOut = numChannels;
    verbosity = verbose;

    if(forceRebuild.not, {
      "Not rebuilding %. Reading defaults from SynthDescLib.".format(this.name).warn;
      SynthDescLib.read();
    });

    Server.local.doWhenBooted{
      this.load();
    }
  }

  *load{
    fork{
      this.loadMessage;

      // @FIXME this is done by the KComponentManager sub classes, so maybe it isn't need here?
      KLoad.loadAll();
      Server.local.sync;

      KEnvelopes.new();
      Server.local.sync;

      KFilters.new();
      Server.local.sync;

      KPanners.new();
      Server.local.sync;

      KGrainShapes.new();
      Server.local.sync;

      this.loadSourceFunctions();
      Server.local.sync;

      initialized = true;
    }
  }

  *sndPath{
    ^path +/+ "snd"
  }

  *getName{|basename ... nameComponents|
    var name = "%".format(basename);

    nameComponents.do{|nameComponent|
      name = name ++ "_%".format(nameComponent)
    };

    // Append number of outchannels to end
    name = name ++ "_o" ++ numChansOut.asString;

    ^name.asSymbol
  }

  *add{|basename, synthfunc, numChannelsIn=1|
    KEnvelopes().keys.do{|envType|
      KFilters().keys.do{|filterType|
        var name = this.getName(basename, envType, filterType);

        // Wrap the input function
        var func = { | dur=1, amp=0.25|

          // Get source function
          var sig = SynthDef.wrap(synthfunc, prependArgs: [ dur ]);

          sig = KFilters().getWrap(filterType, "f", "", envType, sig, dur, 0);

          sig = KPanners().getWrap(numChannelsIn, numChansOut, "", "", sig);

          sig * amp
        };

        this.addBasicSynthFunc(name, func);
        this.makeSynthDef(name, func, envType);
        this.addSynthName(name, basename, envType, filterType);

      }
    }
  }

  // Add a basic synth function that does not have Out-stuff or VCA stuff.
  *addBasicSynthFunc{|synthdefName, func|
      synthFuncs[synthdefName] = func
  }

  // This will get a function witout vca and Out.
  // Appropriate for nodeproxy or at the root of a SynthDef
  *getFunc{|basename, envType=\adsr, filterType=\korg35|
      var synthdefName = this.get(basename, envType, filterType);
      ^this.getFuncRaw(synthdefName)
  }

  // Get function using full synthdefname
  *getFuncRaw{|synthdefName|
      ^if(synthFuncs[synthdefName].notNil and: { synthdefName.notNil }, {
          synthFuncs[synthdefName]
      }, {
          this.poster("Could not find synthdefname % in synthfuncs dictionary.".format(synthdefName), error: true);
          nil
      })

  }

  *makeSynthDef{|name, func, envType|
    if(forceRebuild, {
      SynthDef.new(name.asSymbol,
          {|out=0, envDone=2, dur=1|

              var sig = SynthDef.wrap(func, prependArgs: [ dur ]);

              // Apply VCA envelope
              sig = sig * KEnvelopes().getWrap(envType, "vca", "", dur, envDone);

              Out.ar(out, sig);
          }
      ).load;

      this.poster("Added SynthDef %".format(name));
    });
  }

  // Synthdef names
  // @TODO
  *addSynthName{|name, basename, envType, filterType|
    // [name, basename, envType, filterType].postln;

    synthNames = synthNames.add(name.asSymbol);

    basename = basename.asSymbol;
    envType = envType.asSymbol;
    filterType = filterType.asSymbol;

    synths.at( basename ) ?? { synths.put(basename, IdentityDictionary.new) };
    synths.at( basename ).at( envType ) ?? { synths.at(basename).put(envType, IdentityDictionary.new) };
    synths.at( basename ).at( envType ).put(filterType, name);
  }

  *at{|basename|
    this.checkIfInitialized();
    if(synths.keys.includes(basename.asSymbol), {
      ^synths.at(basename)
    }, {
      "% is not in %".format(basename, this.name).error;
      ^nil
    })
  }

  // This method is probably over complicated but at least it's very friendly!
  // @TODO wrong env type does not trigger error
  *get{|basename, envType=\adsr, filterType=\korg35|
    var base;
    base = this.at(basename);

    ^if(base.notNil, {
      if(base.keys.includes(envType), {
        if(base.at(envType).keys.includes(filterType), {

          base.at(envType).at(filterType).asSymbol;

        }, {

          "No synth for basename % with filter type %.\nMaybe try one of these: %".format(
            basename,
            filterType,
            base.at(envType).keys
          ).error;

          nil
        })

      }, {

        "No synth for basename % with env type %.\nMaybe try one of these: %".format(
          basename,
          envType,
          base.at(envType).keys
      ).error;

      nil
    })
    })

  }

  *argsFor{|basename, envType=\adsr, filterType=\dfm1|
    var sdname = this.get(basename, envType, filterType);
    ^SynthDescLib.at(sdname).controlNames
  }

  *genPat{|basename, envType=\adsr, filterType=\dfm1|
    var sdname = this.get(basename, envType, filterType);
    KGenPat(sdname);
  }

  *poster{|what, error=false|
    var prefix = "";
    verbosity.if({
      var string = "% %".format(prefix, what);
      if(error, {
        string.error;
      }, {
        string.postln;
      })
    })
  }

  *loadMessage{
    if(verbosity, {
      "----------".postln;
      "Loading komet".postln;
    })
  }

  *checkIfInitialized{
    if(initialized.not, {
      "% has not been initialized".format(this).error
      ^false;
    }, { ^true })
  }

  *loadSourceFunctions{
    fork{

      // Synths that need to be manually killed
      (path +/+ "synths").folders.do{|directory|
        directory.filesDo{|file|
            if(file.extension == "scd", {
                var thisPath = file.fullPath;
                this.poster("Loading %".format(file.fileName));
                thisPath.load;
            }, {
                this.poster("Skipping % because it is not a .scd file".format(file.fileName));
            })
        }
      };

      // s.sync;
      this.poster("DONE LOADING KOMET");

      // See and test all loaded SynthDefs:
      // SynthDescLib.global.browse;

    };

  }

  *browse{
    this.checkIfInitialized();
    KSynthBrowser.new(synthNames)
  }

  *installFaustPlugins{
      faustInstaller.install();
  }

  *installDependenciesArch{|aurHelper="paru"|
    "% -S supercollider-squinewave-git supercollider-steroids-ugens-git supercollider-xplaybuf-git supercollider-portedplugins supercollider-mi-ugens-git supercollider-guttersynth-git supercollider-vbugens-git".format(aurHelper).runInTerminal
  }

  *test{
    "Running all tests for M associated classes!!\n".postln;
    TestKLoad.run;
    TestKFilters.run;
    TestKPanners.run;
    TestKGrainShapes.run;
    TestK.run;
  }

}
