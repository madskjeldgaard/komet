Komet {
    classvar <testBuffers;
    classvar <synthFactory, <fxFactory;
    classvar <numChannels;
    classvar <initialized=false;
    classvar <recorder;
    classvar <mode;

    classvar <binauralCIPICDecoder, <binauralListenDecoder, <>cipicID=21, <>listenID=1017, <foaencodermatrix, <foadecoderkernelUHJ;
    classvar <order;

    *record{|path, bus, duration|
        recorder = recorder ?? {Recorder.new(server:Server.local)};

        recorder .recHeaderFormat_("WAV");

        recorder.record(
            path: path ? "~/komet_%.wav".format(Date.getDate.stamp),
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
                file.fileName.beginsWith(KometSynthFactory.synthDefPrefix) ||
                file.fileName.beginsWith(KometFXFactory.synthDefPrefix), {
                Log(\komet).info("CLEAN: Deleting %", file.fileName);
                // File.delete(file)
            })
        }
    }

    *build{|kometChans|
        synthFactory = KometSynthFactory.new(kometChans, rebuild: true);
        fxFactory = KometFXFactory.new(kometChans, rebuild: true);
    }

    *start{|numChannelsOut=2, build=false|
        var kometChans = KometChannels.new(numChannelsOut);
        if(kometChans.check(),{

            if(kometChans.isAmbisonics, {
                mode = \hoa;
                order = kometChans.hoaOrder();
            }, {
                mode = \normal
            });

            Log(\komet).info("Booting in % mode".format(mode));

            numChannels = kometChans.numChannels();

            if(KometDependencies.check(), {
                Server.local.waitForBoot{

                    this.prLoadResources();
                    Server.local.sync;

                    if(build, {
                        this.build(kometChans);
                    }, {
                        synthFactory = KometSynthFactory.new(kometChans, rebuild: false);
                        fxFactory = KometFXFactory.new(kometChans, rebuild: false);
                    });

                    Server.local.sync;
                    this.prSetupChains();

                Server.local.sync;
                initialized = true;

            }
        }, {
            Log(\komet).error("Dependencies not installed or satisfied");
        })
    },{
        Log(\komet).error("%: Invalid KometChannels. Doing nothing".format(this.class.name));
    })

    }

    *browse{
        KSynthBrowser.new(KometSynthLib.get);
    }

    *prSetupChains{
        var addAfter = 1;
        // An empty FX chain that the user can populate if needed
        KometMainChain(\preMain, [], numChannels, addAfter);

        // The main output fx chain
        KometMainChain(\main, [
            KometFXItem.new(\eq3, \channelized, []),
            KometFXItem.new(\leakdc, \channelized, []),
            // TODO:
            // KometFXItem.new(\klimit, \channelized, [])
        ],
        numChannels,
        KometMainChain(\preMain).group
    );

    if(mode == \hoa, {

        KometMainChain(
            \decoder, [],
            numChannels,
            KometMainChain(\main).group
        );

    });
    }

    *prLoadResources{
            if(mode == \hoa, {
                // Ambisonics resources
                binauralCIPICDecoder = FoaDecoderKernel.newCIPIC(cipicID);
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
}
