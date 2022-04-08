/*
*
* Manage FX synth defs
*
*/
KometFXFactory : AbstractKometFactory {
    classvar <types, <fx, <numChannels, <initialized=false, <synthNames, <path;
    classvar <files;
    classvar <synthDefPrefix="kometfx_";

    *initClass{
        StartUp.add({
            var parallelFiles;
            path = KometPath.path;
            files = (path +/+ "synths" +/+ "fx").folders.collect{|dir| dir.files}.flatten;

            // Need to be loaded AFTER the synth folders
            parallelFiles = (path +/+ "synths" +/+ "parallel").files;
            files = files ++ parallelFiles;
        });

    }

    *new{|channels|
        initialized = false;
        synthNames = [];

        channels.isNil.if({
            Log(\komet).error("numChannels not set")
        }, {
            var result;
            types = [\hoa, \channelized, \stereo];
            fx = IdentityDictionary.new;
            types.do{|type| fx.put(type, IdentityDictionary.new)};
            numChannels = channels;

            result = this.loadSourceFunctions(files);

            if(result, {
                Log(\komet).info("Initialized");
                initialized = true;
            }, {
                Log(\komet).warning("Not initialized");
            });

        });
    }

    *add{|basename, type, synthfunc, specs, check|

        var ok = if(check.notNil, { check.value() }, { true });

        if(ok, {
            if(types.includes(type).not or: { type.isNil }, {
                Log(\komet).error("Type % is not one of accepted types", type)
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
            Log(\komet).warning("%: Check failed for basename %".format(this.name, basename))
        })

    }

    *get{|basename, type|
        ^(synthDefPrefix ++ type ++ "_" ++ basename.asString ++ numChannels.asString).asSymbol
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
            Log(\komet).error("Type % does not exist", type);
            nil
        })
    }

    *getFunc{|basename, type|
        ^if(this.basenameExists(basename, type), {
            fx[type][basename][\func]
        }, {
            Log(\komet).error("Could not find dict entry for %", basename)
        })
    }

    *prAddDef{|basename, func, type|

        var defname = this.get(basename, type);
        var numChans = numChannels; // @FIXME: Make work with other channel types
        synthNames = synthNames.add(defname);

        Log(\komet).info("Adding synthdef: %".format(defname));

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
            var bands =  Krossover2.ar(sig, crossoverFreq);

            sig = Array.fill(2, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.prAddDef(basename, func, type)
    }

    // TODO untested
    *addParallel4{|basename1, basename2, basename3, basename4, type|
        // FIXME: Because I'm a lazy fucking idiot:
        var basename = "par4_" ++ basename1.asString ++ "_" ++ basename2.asString ++ "_" ++ basename3.asString ++ "_" ++ basename4.asString;
        var synthDefs = [this.getFunc(basename1, type), this.getFunc(basename2, type),this.getFunc(basename3, type),this.getFunc(basename4, type)];

        var func = {|sig, crossoverFreq1=500, crossoverFreq2=1250, crossoverFreq3=2500|
            var bands =  Krossover4.ar(sig, crossoverFreq1, crossoverFreq2, crossoverFreq3);

            sig = Array.fill(4, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.prAddDef(basename, func, type)
    }

    // TODO
    *prAddHoa{|basename, func, specs|

        var thisType = \hoa;
        var id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.prAddDef(basename, func, thisType);
    }

    *prAddChannelized{|basename, func, specs|
        var id;
        var thisType = \channelized;

        func = func.value(numChannels);
        id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.prAddDef(basename, func, thisType);
    }

    *prAddStereo{|basename, func, specs|
        var thisType = \stereo;
        var id = IdentityDictionary[\func -> func, \specs -> specs];
        fx[thisType].put(basename, id);

        this.prAddDef(basename, func, thisType);
    }

}
