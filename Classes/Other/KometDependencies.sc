KometDependencies : Singleton {

    installFaustPlugins{
        ^M_FaustInstaller.install()
    }

    installPlugins{
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
