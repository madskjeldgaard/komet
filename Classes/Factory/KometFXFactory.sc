/*
*
* Manage FX synth defs
*
*/
KometFXFactory : AbstractKometFactory {
    classvar <kometChannels, <initialized=false, <path;
    classvar <forceRebuild=false;

    // TODO: Use rebuild
    *new{|channels, rebuild=false|
        initialized = false;
        forceRebuild = rebuild;

        if(channels.isKometChannel, {
            if(channels.check(), {
                var result;
                if(forceRebuild.not, {
                    "Not rebuilding %. Reading defaults from SynthDescLib.".format(this.name).warn;
                    SynthDescLib.read();
                });

                kometChannels = channels;

                result = this.loadSourceFunctions(KometSynthLib.files[\fx]);

                if(result, {
                    initialized = true;
                }, {
                    Log(\komet).warning("Not initialized");
                });
            });
        }, {
            Log(\komet).error("%: Not a valid KometChannel".format(this.class.name));
        })

    }

    *prAddSynthDef{|kometSynthFuncDef|
        if(kometSynthFuncDef.category == \hoa && kometChannels.isAmbisonics.not, {
            // Skip if Komet is not in HOA mode and the synthdef is a hoa one
            Log(\komet).debug("Skipping and clearing kometSynthFuncDef % because Komet is not in HOA mode and it is a HOA synth", kometSynthFuncDef.name);
            kometSynthFuncDef.clear();
        }, {

            var synthdefname = kometSynthFuncDef.synthdefName();
            var type = kometSynthFuncDef.type;
            var category = kometSynthFuncDef.category;
            var baseName = kometSynthFuncDef.name;
            var builtFunc = {|out, drywet=1.0, fadeInTime=1.0, fadeOutTime=8, gate=1|

                // var fadeIn = Line.ar(0,1,fadeInTime);
                var fadeIn = EnvGen.kr(
                    envelope:Env.new([0,1,0], [fadeInTime, fadeOutTime], releaseNode: 1),
                    gate:gate,
                    doneAction:\doneAction.ir(0)
                );

                var clean = fadeIn * In.ar(
                    bus:out,
                    numChannels:kometChannels.numChannels
                );

                var sig = clean;

                sig = SynthDef.wrap(
                    switch (category,
                        \channelized, {
                            kometSynthFuncDef.func.value(kometChannels.numChannels)
                        },
                        \hoa, {
                            kometSynthFuncDef.func.value(kometChannels.hoaOrder())
                        },
                        \stereo, {
                            kometSynthFuncDef.func
                        },
                    ),
                    prependArgs: [sig]
                );

                sig = XFade2.ar(clean, sig, drywet.linlin(0.0,1.0,-1.0,1.0));
                ReplaceOut.ar(out, sig * fadeIn);
            };

            var synthdef = SynthDef(synthdefname, builtFunc);

            // Add default specs
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\drywet, [0.0, 1.0, \lin, nil, 1].asSpec);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\fadeInTime, [0.0001, 10.0, \exp, nil, 1].asSpec);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\fadeOutTime, [0.0001, 10.0, \exp, nil, 8].asSpec);

            KometSynthLib.put(type, category, baseName, \rawFunc, kometSynthFuncDef.func);
            KometSynthLib.put(type, category, baseName, \builtFunc, builtFunc);
            KometSynthLib.put(type, category, baseName, \synthDefName, synthdefname);
            KometSynthLib.put(type, category, baseName, \synthDef, synthdef);
            KometSynthLib.put(type, category, baseName, \kometSynthFuncDef, kometSynthFuncDef);

            Log(\komet).debug("Added SynthDef %", synthdefname);
            Log(\komet).debug("\t %", kometSynthFuncDef.text);

            if(forceRebuild, {
                Log(\komet).debug("Loading SynthDef %", synthdefname);
                // Save to disk and load the synthdef
                synthdef.load;
            })
        });

    }
}
