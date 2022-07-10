KometDependencies {

    *check{
        var checked = IdentityDictionary.new;

        // Check if your faust installation is supported:
        checked.put(\faustVersion, Faust.checkVersion("2.40.0"));

        // Check if external plugins are installed
        // Ported Plugins
        checked.put(\portedPluginsInstalled, \Rongs.asClass.notNil);

        // XPlaybuf
        // checked.put(\xplaybufInstalled, \XPlayBuf.asClass.notNil);

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

    *prInstallUsingPluginsQuark{
        // Use Plugins.quark
        var dependencies = Quark("komet").data.plugin_dependencies;
        dependencies.do{|depend|
            Log(\komet).info("Installing plugin " ++ depend);
            Plugins.installPlugin(depend)
        }
    }

    *installPlugins{
        Platform.case(
            \osx,       {
                this.prInstallUsingPluginsQuark();
            },
            \linux,     {
                var isArchLinux = "command -v pacman".systemCmd == 0;

                // Use an AUR helper to install dependencies
                if(isArchLinux, {
                    // Install packages via aur
                    var dependencies = Quark("komet").data.aur_dependencies;
                    K_AURHelper.install(dependencies)
                }, {
                    this.prInstallUsingPluginsQuark();
                })

            },
            \windows,   {
                //TODO: No idea if this works
                this.prInstallUsingPluginsQuark();
            }
        );
    }

}
