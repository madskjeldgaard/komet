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

    // TODO: Should the synthdef compilation be put in here?
    *install{
        KometDependencies.installFaustPlugins();
        KometDependencies.installPlugins();
    }

    //TODO
    *compile{
        // synthFactory = KometSynthFactory.new(numChannelsOut, rebuild: false);
        // fxFactory = KometFXFactory.new(numChannelsOut);
    }

    *start{|numChannelsOut=2, rebuild=true|
        numChannels = numChannelsOut;
        if(KometDependencies.check(), {
            synthFactory = KometSynthFactory.new(numChannelsOut, rebuild: false);
            fxFactory = KometFXFactory.new(numChannelsOut);
            mainOut = KometMain.new();
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
}
