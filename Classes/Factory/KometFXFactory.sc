/*
*
* Manage FX synth defs
*
*/
KometFXFactory : AbstractKometFactory {
    classvar <numChannels=2, <initialized=false, <path;
    classvar <forceRebuild=false;

    // TODO: Use rebuild
    *new{|channels, rebuild=false|
        initialized = false;

        forceRebuild = rebuild;

        if(forceRebuild.not, {
            "Not rebuilding %. Reading defaults from SynthDescLib.".format(this.name).warn;
            SynthDescLib.read();
        });

        channels.isNil.if({
            Log(\komet).error("numChannels not set")
        }, {
            var result;
            numChannels = channels;

            result = this.loadSourceFunctions(KometSynthLib.files[\fx]);

            if(result, {
                initialized = true;
            }, {
                Log(\komet).warning("Not initialized");
            });

        });
    }

    *prAddSynthDef{|kometSynthFuncDef|
        var synthdefname = kometSynthFuncDef.synthdefName();
        var type = kometSynthFuncDef.type;
        var category = kometSynthFuncDef.category;
        var baseName = kometSynthFuncDef.name;
        var builtFunc = {|out, drywet=0.5, fadeInTime=1.0, fadeOutTime=8, gate=1|

            // var fadeIn = Line.ar(0,1,fadeInTime);
            var fadeIn = EnvGen.kr(
                envelope:Env.new([0,1,0], [fadeInTime, fadeOutTime], releaseNode: 1),
                gate:gate,
                doneAction:\doneAction.ir(0)
            );

            var sig = fadeIn * In.ar(
                bus:out,
                numChannels:numChannels
            );

            sig = SynthDef.wrap(
                if(category == \channelized, {kometSynthFuncDef.func.value(numChannels)}, { kometSynthFuncDef.func }),
                prependArgs: [sig]
            );

            XOut.ar(out, fadeIn * drywet, sig)
        };

        var synthdef = SynthDef(synthdefname, builtFunc);

        KometSynthLib.put(type, category, baseName, \rawFunc, kometSynthFuncDef.func);
        KometSynthLib.put(type, category, baseName, \builtFunc, builtFunc);
        KometSynthLib.put(type, category, baseName, \synthDefName, synthdefname);
        KometSynthLib.put(type, category, baseName, \synthDef, synthdef);
        KometSynthLib.put(type, category, baseName, \kometSynthFuncDef, kometSynthFuncDef);

        Log(\komet).info("Added SynthDef %", synthdefname);
        Log(\komet).info("\t %", kometSynthFuncDef.text);

        if(forceRebuild, {
            Log(\komet).info("Loading SynthDef %", synthdefname);
            // Save to disk and load the synthdef
            synthdef.load;
        })

    }
}
