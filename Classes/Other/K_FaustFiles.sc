K_FaustFiles : Singleton {
    classvar <installer;
    *initClass{
        StartUp.add({

            var path = PathName(Main.packages.asDict.at(pkgName));
            // This will trigger compilation if it hasn't already been compiled
            installer = K_FaustInstaller.new(
                // Will be compiled to extensions/...
                "KometFaustPlugins",
                // Source of faust files
                sourcecodeDir: path +/+ "faust",
                // Trigger autocompile if folder does not exist
                autoCompile: true
            );
        })
    }

}
