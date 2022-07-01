KometDependencies {

    *check{
        var checked = IdentityDictionary.new;

        // Check if your faust installation is supported:
        checked.put(\faustVersion, Faust.checkVersion("2.40.0"));

        // Check if external plugins are installed
        // Ported Plugins
        checked.put(\portedPluginsInstalled, \Rongs.asClass.notNil);

        // XPlaybuf
        checked.put(\xplaybufInstalled, \XPlayBuf.asClass.notNil);

        // Squine wave
        checked.put(\squineWaveInstalled, \Squine.asClass.notNil);

        // Gutter Synth
        checked.put(\gutterSynthInstalled, \GutterSynth.asClass.notNil);

        // SafetyLimiter Synth
        checked.put(\safetyLimiterInstalled, \SafetyLimiter.asClass.notNil);

        // VSTPlugin
        // checked.put(\vstpluginInstalled, \VSTPlugin.asClass.notNil);

        checked.keysValuesDo{|check, result|
            Log(\komet).debug("Dependency check: %, result: %", check, result);
        };

        ^checked.every{|isTrue| isTrue }
    }

    *installFaustPlugins{
        Log(\komet).info("Installing Faust plugins");
        ^KometFaustPackage.install()
    }

    *installPlugins{
        Platform.case(
            \osx,       {
                "TODO".warn
            },
            \linux,     {
                var isArchLinux = "command -v pacman".systemCmd == 0;

                if(isArchLinux, {
                    // Install packages via aur
                    var dependencies = Quark("komet").data.aur_dependencies;
                    K_AURHelper.install(dependencies)
                }, {
                    "Only arch linux is supported".warn
                })

            },
            \windows,   {
                "Not supported".error.throw
            }
        );
    }

}
