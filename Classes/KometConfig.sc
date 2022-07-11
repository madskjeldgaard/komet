KometConfig{
    classvar <path, <config;
    *initClass{
        // Class.initClassTree(KometPreset);
        StartUp.add({
            // Path to config file
            path = KometPreset.resourcePath +/+ "config.scd";

            // Make config if necesasry
            if(path.isFile.not, {
                Log(\komet).info("No config file found at %.\nGenerating one now.".format(path.fullPath));
                this.generateConfigFile()
            });

            // Load config
            config = path.fullPath.load();
        })
    }

    *generateConfigFile{
        var config = "(
    numChannelsOut: 2,
    build: true,
    openGuiAfterInit: true,
    loglevel: \debug,
    chains: (
        preMain: [
        ],
        main: [
            [\eq3, \channelized, []],
            [\leakdc, \channelized, []],
        ],
        decoder: [
            [\binaurallistendecoder, \hoa, []]
        ]
    ),
    hoa: (
        // IDs of models for binauraldecoders
        cipicID: 21,
        listenID: 1017,
    )
)";
        var file = File.open(pathName:path.fullPath, mode:"w");
        file.write(config);
        file.close();

    }
}
