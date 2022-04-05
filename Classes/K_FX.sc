/*
*
* Manage FX synth defs
*
*/
K_FX {
    classvar <types, <fx, <numChannels, <initialized=false, <synthNames, <path, <pkgName='mk-fxlib', <files, <faustFiles, <faustInstaller;

    *initClass{
        StartUp.add({
            path = PathName(Main.packages.asDict.at(pkgName));
            files = (path +/+ "synths").folders.collect{|dir| dir.files}.flatten;
            faustFiles =(path +/+ "faust").files.select{|ff| ff.extension == "dsp"};

        });

        StartUp.add({
            // This will trigger compilation if it hasn't already been compiled
            faustInstaller = K_FaustInstaller.new(
                // Will be compiled to extensions/K_FxLibFaustPlugins
                "K_FXLibFaustPlugins",
                // Source of faust files
                sourcecodeDir: path +/+ "faust",
                // Trigger autocompile if folder does not exist
                autoCompile: true
            );
        })
    }

    *new{|channels|
        initialized = false;
        synthNames = [];

        channels.isNil.if({
            "%: numChannels not set".format(this.name).error
        }, {
            types = [\hoa, \channelized, \stereo];
            fx = IdentityDictionary.new;
            types.do{|type| fx.put(type, IdentityDictionary.new)};
            numChannels = channels;

            this.load();
            initialized = true;

        });
    }

    *browse{
        K_SynthBrowser.new(synthNames)
    }

    *load{
        var synthFolders, parallelFiles;
        var packageName = 'mk-fxlib';
        path = PathName(Main.packages.asDict.at(packageName));
        synthFolders =  (path +/+ "synths").folders;

        // Need to be loaded AFTER the synth folders
        parallelFiles = (path +/+ "parallel").files;

        synthFolders.do{|f|
            f.files.do({|file|
                file.fullPath.load()
            });
        };

        parallelFiles.do{|f|
            f.fullPath.load();
        }

    }

    *addFX{|basename, type, synthfunc, specs, check|

        var ok = if(check.notNil, { check.value() }, { true });

        if(ok, {
            if(types.includes(type).not or: { type.isNil }, {
                "%: Type % is not one of accepted types".format(type, this.name).error
            }, {
                case
                { type == \hoa }   {
                    this.prAddHoa(basename, synthfunc, specs)
                }
                { type == \channelized } {
                    this.prAddChannelized(basename, synthfunc, specs)
                }
                { type == \stereo } {
                    this.prAddStereo(basename, synthfunc, specs)
                };
            })
        }, {
            "%: Check failed for basename %".format(this.name, basename).warn
        })

    }

    *get{|basename, type|
        ^("mfx_" ++ type ++ "_" ++ basename.asString ++ numChannels.asString).asSymbol
    }

    *typeExists{|type|
        ^if(fx[type].isNil, {
            false
        }, {
            true
        })
    }

    *basenameExists{|basename, type|
        ^if(this.typeExists(type), {
            var dict = fx[type][basename];

            if(dict.notNil, {
                true
            }, {
                false
            })

        }, {
            "%: Type % does not exist".format(this.name, type).error;
            nil
        })
    }

    *getFunc{|basename, type|
        ^if(this.basenameExists(basename, type), {
            fx[type][basename][\func]
        }, {
            "%: Could not find dict entry for %".format(this.name, basename).error
        })
    }

    *addDef{|basename, func, type|

        var defname = this.get(basename, type);
        var numChans = numChannels; // @FIXME: Make work with other channel types
        synthNames = synthNames.add(defname);

        "%: Adding synthdef: %".format(this.name, defname).postln;

        SynthDef(defname, {|out, drywet=0.5, fadeInTime=1.0, fadeOutTime=8, gate=1|

            // var fadeIn = Line.ar(0,1,fadeInTime);
            var fadeIn = EnvGen.kr(
                envelope:Env.new([0,1,0], [fadeInTime, fadeOutTime], releaseNode: 1),
                gate:gate,
                doneAction:\doneAction.ir(0)
            );
            var sig = fadeIn * In.ar(bus:out, numChannels:numChans);
            sig = SynthDef.wrap(func, prependArgs: [sig]);

            XOut.ar(out, fadeIn * drywet, sig)

        }).load;
    }

    *addParallel2{|basename1, basename2, type|
        var basename = "par2_" ++ basename1.asString ++ "_" ++ basename2.asString;
        var synthDefs = [this.getFunc(basename1, type), this.getFunc(basename2, type)];

        var func = {|sig, crossoverFreq=500|
            var bands =  BandSplitter2.ar(sig:sig, freq:crossoverFreq, order:2);

            sig = Array.fill(2, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.addDef(basename, func, type)
    }

    // TODO untested
    *addParallel4{|basename1, basename2, basename3, basename4, type|
        // FIXME: Because I'm a lazy fucking idiot:
        var basename = "par4_" ++ basename1.asString ++ "_" ++ basename2.asString ++ "_" ++ basename3.asString ++ "_" ++ basename4.asString;
        var synthDefs = [this.getFunc(basename1, type), this.getFunc(basename2, type),this.getFunc(basename3, type),this.getFunc(basename4, type)];

        var func = {|sig, crossoverFreq1=500, crossoverFreq2=1250, crossoverFreq3=2500|
            var bands =  BandSplitter4.ar(sig, crossoverFreq1, crossoverFreq2, crossoverFreq3, order:2);

            sig = Array.fill(4, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.addDef(basename, func, type)
    }

    // TODO
    *prAddHoa{|basename, func, specs|

        var thisType = \hoa;
        var id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.addDef(basename, func, thisType);
    }

    *prAddChannelized{|basename, func, specs|
        var id;
        var thisType = \channelized;

        func = func.value(numChannels);
        id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.addDef(basename, func, thisType);
    }

    *prAddStereo{|basename, func, specs|
        var thisType = \stereo;
        var id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.addDef(basename, func, thisType);
    }

    *installFaustPlugins{
        faustInstaller.install();
    }

}
