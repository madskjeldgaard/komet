Komet {
    classvar <synthFactory, <fxFactory;
    classvar <files, <faustFiles, <allFiles, <mainOut, <numChannels;

    *initClass{
        StartUp.add{
            files = KometSynthFactory.files ++ KometFXFactory.files;
            faustFiles = KometSynthFactory.faustFiles;
            allFiles = files ++ faustFiles;
        }
    }

    *install{
        KometDependencies.installFaustPlugins();
        KometDependencies.installPlugins();
    }

    //TODO
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
                [\eq3, \channelized, []]
            ],
            numChannels,
            KometMainChain(\preMain).group
        );

            // TODO:
            // KometMain(\leak, numChannels, addAfter, \eq3, \channelized);
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
