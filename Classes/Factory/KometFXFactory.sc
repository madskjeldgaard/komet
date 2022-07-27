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

                // Add send, etc.
                this.prAddBasicSynthDefs();

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

    *prAddBasicSynthDefs{
        this.prAddSendSynthDef();
    }

    *prAddSendSynthDef{
        Log(\komet).debug("Adding komet_send synthdef");

        SynthDef.new(\komet_send, {|inbus, outbus, level=1, fadeInTime=0.0, fadeOutTime=0.0, fadeCurve(-4), gate=1|
            // FIXME: Fade is only used to free synth. Messy!!
            var fadeIn = EnvGen.kr(
                envelope:Env.new(
                    [0,1,0],
                    [fadeInTime, fadeOutTime],
                    fadeCurve,
                    releaseNode: 1
                ),
                gate:gate,
                doneAction:\doneAction.ir(0)
            );

            var clean = In.ar(
                bus:inbus,
                numChannels:kometChannels.numChannels
            );

            var sig = clean;

            sig = sig * level;

            Out.ar(outbus, sig);
        }).add;

    }

    *prAddSynthDef{|kometSynthFuncDef|
        if(kometSynthFuncDef.category == \hoa && kometChannels.isAmbisonics.not, {
            // Skip if Komet is not in HOA mode and the synthdef is a hoa one
            Log(\komet).debug("Skipping and clearing kometSynthFuncDef % because Komet is not in HOA mode and it is a HOA synth", kometSynthFuncDef.name);
            kometSynthFuncDef.clear();
        }, {

            // var synthdefname = kometSynthFuncDef.synthdefName();
            var type = kometSynthFuncDef.type;
            var category = kometSynthFuncDef.category;
            var baseName = kometSynthFuncDef.name;

            var synthdefname = Komet.synthdefName(kometSynthFuncDef.type, kometSynthFuncDef.name, kometSynthFuncDef.category);
            var builtFunc = {|out, drywet=1.0, fadeInTime=0.0, fadeOutTime=0.0, fadeCurve(-4), gate=1|

                // var fadeIn = Line.ar(0,1,fadeInTime);
                var fadeIn = EnvGen.kr(
                    envelope:Env.new(
                        [0,1,0],
                        [fadeInTime, fadeOutTime],
                        fadeCurve,
                        releaseNode: 1
                    ),
                    gate:gate,
                    doneAction:\doneAction.ir(0)
                );

                var clean = fadeIn * In.ar(
                    bus:out,
                    numChannels:kometChannels.numChannels
                );

                var sig = clean;

                // Apply the FX
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
                sig = sig * fadeIn;

                ReplaceOut.ar(out, sig);  // "maintains on own bus"
            };

            var synthdef = SynthDef(synthdefname, builtFunc);

            // Add default specs
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\drywet, KometSpecs.specs[\drywet]);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\lagTime, KometSpecs.specs[\lagTime]);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\fadeCurve, KometSpecs.specs[\fadeCurve]);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\fadeInTime, KometSpecs.specs[\fadeTime]);
            kometSynthFuncDef.specs = kometSynthFuncDef.specs.put(\fadeOutTime, KometSpecs.specs[\fadeTime]);

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
