AbstractKometFactory{
    *loadSourceFunctions{|files|
        var loaded = [];
        var lastFile;
        var result;

        // Synths that need to be manually killed
        // FIXME: This would be faster if it would break the do-loop on fail
        files.do{|file|
            if(loaded.every{|isTrue| isTrue}, {
                if(file.extension == "scd", {
                    var thisPath = file.fullPath;
                    var result;
                    Log(\komet).debug("Loading %".format(file.fileName));
                    lastFile = thisPath;
                    result = thisPath.load;
                    loaded = loaded.add(result.notNil);
                }, {
                    Log(\komet).debug("Skipping % because it is not a .scd file".format(file.fileName));
                })
            });

        };

        result = loaded.every{|isTrue| isTrue};
        if(result, {
            Log(\komet).info("Loaded %", this.name);
        }, {
            Log(\komet).error("Something went wrong while loading source function %. Aborting load.", lastFile);
        })

        ^result
    }

    *load{|kometSynthFuncDef|
        if(kometSynthFuncDef.class == KometSynthFuncDef, {
            if(kometSynthFuncDef.check(), {

                Log(\komet).info("Reading file containing SynthDef: %".format(kometSynthFuncDef.synthdefName()));

                this.prAddSynthDef(
                    kometSynthFuncDef
                );

            }, {
                Log(\komet).info("%: Check failed for basename %. Ignoring it.".format(this.name, kometSynthFuncDef.name))
            })
        }, {
            Log(\komet).error("%: Could not add synth. It is not the correct type:%".format(this.name, kometSynthFuncDef))
        })

    }

    *prAddSynthDef{|kometSynthFuncDef|
        this.subclassResponsibility(thisMethod);
    }
}
