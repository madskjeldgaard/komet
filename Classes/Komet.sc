Komet : Singleton {
    classvar <synthFactory, <fxFactory;
    classvar <files, <faustFiles, <allFiles;

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

    *start{|numChannelsOut=2, rebuild=true, verbose=true|
        if(KometDependencies.check(), {
            synthFactory = KometSynthFactory.new(numChannelsOut, rebuild, verbose);
            fxFactory = KometFXFactory.new(numChannelsOut);
        }, {
            Log(\komet).error("Dependencies not installed or satisfied");
        })

    }

    *browse{
        // TODO:
        // this.isInitialized();
        KSynthBrowser.new(KometSynthFactory.synthNames ++ KometFXFactory.synthNames);
    }

    // TODO
    // Get a synthdef name
    *get{

    }
}
