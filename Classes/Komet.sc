Komet {
    classvar <testBuffers;
    classvar <synthFactory, <fxFactory;
    classvar <numChannels;
    classvar <initialized=false;
    classvar <recorder;
    classvar <mode;
    classvar <synthDefPrefix="komet";

    classvar <binauralCIPICDecoder, <binauralListenDecoder, <>cipicID=21, <>listenID=1017, <foaencodermatrix, <foadecoderkernelUHJ;
    classvar <order;
    classvar <>resourcePath; // Gets set by KometPreset

    *record{|path, bus, duration|
        recorder = recorder ?? {Recorder.new(server:Server.local)};

        recorder.recHeaderFormat_("WAV");

        recorder.record(
            path: path ? "~/komet_%_%.wav".format(Date.getDate.stamp, if(mode == \hoa, {AtkHoa.format}).join("_")).asAbsolutePath,
            bus: bus,
            numChannels: numChannels,
            node: KometMainChain(\main).group,
            duration: duration
        )

    }

    *stopRecording{
        recorder.stopRecording;
    }

    *gui{
        KometGui.new()
    }

    *allChains{
        ^KometMainChain.all
    }

    *logLevel{|level|
        Log(\komet).level = level
    }

    *initClass{
        // StartUp.add({ })
    }

    *install{
        KometDependencies.installFaustPlugins();
        KometDependencies.installPlugins();
    }

    *uninstall{
        Log(\komet).info("Uninstalling %", this.name);
        this.clean();
        KometFaustPackage.uninstall();
    }

    // TODO
    // Remove all generated synthdefs
    *clean{
        PathName(
            Platform.userAppSupportDir +/+ "synthdefs"
        ).files.do{|file|
            if(
                file.fileName.beginsWith(synthDefPrefix), {
                Log(\komet).info("CLEAN: Deleting %", file.fileName);
                File.delete(file.fullPath)
            })
        }
    }

    *build{|kometChans|
        synthFactory = KometSynthFactory.new(kometChans, rebuild: true);
        fxFactory = KometFXFactory.new(kometChans, rebuild: true);
    }

    *start{|numChannelsOut, build, openGuiAfterInit, action, loglevel|
        var kometChans = KometChannels.new(numChannelsOut ? KometConfig.config[\numChannelsOut] ? 2);

        initialized.not.if({
            if(kometChans.check(),{
                // Set log level
                this.logLevel(loglevel ? KometConfig.config[\loglevel] ? \debug);

                // Set mode
                if(kometChans.isAmbisonics, {
                    mode = \hoa;
                    order = kometChans.hoaOrder();
                }, {
                    mode = \normal
                });

                Log(\komet).info("Booting in % mode".format(mode));

                numChannels = kometChans.numChannels();

                if(numChannels > Server.local.options.numInputBusChannels, {
                    Log(\komet).warning(
                        "Number of output channels exceed number of inputs channels. This means that internal microphone might be audible in fx synths"
                    );
                });

                if(KometDependencies.check(), {
                    if(Server.local.hasBooted.not, {
                        Log(\komet).warning("Server hasn' booted yet. Booting it now.")
                    });

                    Server.local.waitForBoot{
                        this.prDoWhenBooted(numChannelsOut, build, openGuiAfterInit, action, loglevel, kometChans);
                        // Done
                        Log(\komet).info("DONE LOADING");
                    }
                }, {
                    Log(\komet).error("Dependencies not installed or satisfied");
                })
            },{
                Log(\komet).error("%: Invalid KometChannels. Doing nothing".format(this.class.name));
            })
        }, {
            Log(\komet).warning("Already initialized. Not starting again.")
        })
    }

    // This is where the actual init happens after server is booted
    // It runs in a fork
    *prDoWhenBooted{|numChannelsOut, build, openGuiAfterInit, action, loglevel, kometChans|

        this.prLoadResources();
        Server.local.sync;

        if(build ? KometConfig.config[\build], {
            this.build(kometChans);
        }, {
            synthFactory = KometSynthFactory.new(kometChans, rebuild: false);
            fxFactory = KometFXFactory.new(kometChans, rebuild: false);
        });

        Server.local.sync;
        1.wait;
        this.prSetupChains();

        // Open gui after boot
        if(openGuiAfterInit ? KometConfig.config[\openGuiAfterInit], {
            this.gui()
        });

        // Call action when booted
        Server.local.sync;
        if(action.notNil, {
            action.value();
        });

        // Call extension actions
        KometSynthLibExt.allSubclasses.do{|extClass|
            Server.local.sync;
            extClass.postInit()
        };

        Server.local.sync;
        initialized = true;

    }

    *browse{
        KSynthBrowser.new(KometSynthLib.allSynthDefNames());
    }

    *prSetupChains{
        var addAfter = 1;
        var mainchain, premainchain, decoderchain;
        // An empty FX chain that the user can populate if needed
        premainchain = KometConfig.config[\chains][\preMain].collect{|i| i.asKometFXItem} ?? [];
        KometMainChain(\preMain, premainchain, numChannels, addAfter);

        KometMainChain(\main, KometConfig.config[\chains][\main].collect{|i| i.asKometFXItem}, numChannels, KometMainChain(\preMain).group);

    // Add a decoder chain after the other ones if in hoa mode
    if(mode == \hoa, {
        decoderchain = KometConfig.config[\chains][\decoder].collect{|i| i.asKometFXItem} ?? [];
        KometMainChain(\decoder, decoderchain, numChannels, KometMainChain(\main).group);

    });
    }

    *prLoadResources{
            if(mode == \hoa, {
                // Ambisonics resources
                cipicID = KometConfig.config[\hoa][\cipicID] ? cipicID ? 21;
                binauralCIPICDecoder = FoaDecoderKernel.newCIPIC(cipicID);
                listenID = KometConfig.config[\hoa][\listenID] ? listenID ? 1017;
                binauralListenDecoder = FoaDecoderKernel.newListen(listenID);
                foaencodermatrix = FoaEncoderMatrix.newHoa1;
                foadecoderkernelUHJ = FoaDecoderKernel.newUHJ;

            }, {
                // "normal mode only resources" if any
            });
            testBuffers = BufFiles.new(Server.local, KometPath.sndPath)

    }

    // TODO
    // Get a synthdef name
    *get{

    }

    *test{
        var fails = [];

        // TODO make this synchronous
        // forkIfNeeded{
        //     Server.local.boot;
            KometTest.subclasses.do{|sub|
                Log(\komet).info("Running test for %".format(sub.class.name));
                // Server.local.sync;
                sub.run();
                fails = fails.add(sub.failures.any{|res| res});
            };
        // }

        ^fails.any{|res| res}.not
    }

    *allClasses{
        ^Quarks.classesInPackage(KometPath.pkgName)
    }

    *playSoundfile{|filename, numFileChannels, withFX, fxArgs|
        var synthdefname = "kometfileplayer" ++ numFileChannels;
        var buffer;
        var group;

        fork{
            SynthDef(synthdefname, { |out, buffer = 0|
                Out.ar(out, DiskIn.ar(numFileChannels, buffer));
            }).add;

            Server.local.sync;
            Log(\komet).info("Loading soundfile %", filename);
            buffer = Buffer.cueSoundFile(Server.local, filename, 0, numFileChannels, completionMessage: {|buf|
            });

            Server.local.sync;
            group = Group.new;
            Server.local.sync;
            Log(\komet).info("Playing soundfile %", filename);
            Synth.head(group, synthdefname, [\buffer, buffer]);

            if(withFX.notNil, {
                Server.local.sync;
                Log(\komet).info("Adding FX % to file player group", withFX);
                Synth.tail(group, KometSynthFuncDef(withFX).synthdefName, fxArgs)
            });
        }
    }
}
