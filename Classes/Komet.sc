Komet {
    classvar <testBuffers;
    classvar <synthFactory, <fxFactory;
    classvar <mainOut, <numChannels;
    classvar <initialized=false;

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
        ServerBoot.add{
            testBuffers = BufFiles.new(Server.local, KometPath.sndPath)
        }
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

    *build{|numChannelsOut|
        var kometChans = KometChannels.new(numChannelsOut);
        // TODO
        synthFactory = KometSynthFactory.new(kometChans, rebuild: true);
        fxFactory = KometFXFactory.new(kometChans, rebuild: true);
    }

    *start{|numChannelsOut=2, build=false|
        var kometChans = KometChannels.new(numChannelsOut);
        if(kometChans.check(),{
            numChannels = kometChans.numChannels();
            if(KometDependencies.check(), {
                var addAfter = 1;

                if(build, {
                    this.build(numChannels);
                }, {
                    synthFactory = KometSynthFactory.new(kometChans, rebuild: false);
                    fxFactory = KometFXFactory.new(kometChans, rebuild: false);
                });

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

            initialized = true;

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
