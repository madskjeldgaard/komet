Komet {
    classvar <testBuffers;
    classvar <synthFactory, <fxFactory;
    classvar <mainOut, <numChannels;

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
        synthFactory = KometSynthFactory.new(numChannelsOut, rebuild: true);
        fxFactory = KometFXFactory.new(numChannelsOut, rebuild: true);
    }

    *start{|numChannelsOut=2, build=false|
        numChannels = numChannelsOut;
        if(KometDependencies.check(), {
            var addAfter = 1;

            if(build, {
                this.build(numChannels);
            }, {
                synthFactory = KometSynthFactory.new(numChannelsOut, rebuild: false);
                fxFactory = KometFXFactory.new(numChannelsOut, rebuild: false);
            });

            // An empty FX chain that the user can populate if needed
            KometMainChain(\preMain, [], numChannels, addAfter);

            // The main output fx chain
            KometMainChain(\main, [
                KometFXItem.new(\eq3, \channelized, []),
                // TODO:
                // KometFXItem.new(\klimit, \channelized, [])
            ],
            numChannels,
            KometMainChain(\preMain).group
        );

        }, {
            Log(\komet).error("Dependencies not installed or satisfied");
        })

    }

    *browse{
        KSynthBrowser.new(KometSynthFactory.synthNames ++ KometFXFactory.synthNames);
    }

    // TODO
    // Get a synthdef name
    *get{

    }

    *test{
        var fails = [];

        // TODO make this synchronous
        KometTest.subclasses.do{|sub|
            sub.run();
            fails = fails.add(sub.failures.any{|res| res});
        };

        ^fails.any{|res| res}.not
    }

    *allClasses{
        ^Quarks.classesInPackage(KometPath.pkgName)
    }
}
