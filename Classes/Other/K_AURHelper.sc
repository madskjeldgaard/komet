/*
*
* Manage packages on an Arch Linux based operating system
*
*/
K_AURHelper : Singleton{

    // Install packages
    *install{|packages(["supercollider", "sc3-plugins"])|
        var packageString = "";

        if(packages.isString.not && packages.isArray, {

            packages.do{|pack|
                packageString = packageString ++ " " ++ pack
            };

            this.prRunHelperWithCommand("-S " ++ packageString)
        }, {
            "%: packages must be array".format(this.name).error
        });
    }

    // But why would you?
    *uninstall{|packages([])|
        var packageString = "";

        if(packages.isString.not && packages.isArray, {

            packages.do{|pack|
                packageString = packageString ++ " " ++ pack
            };

            this.prRunHelperWithCommand("-R " ++ packageString)
        }, {
            "%: packages must be array".format(this.name).error
        });
    }

    // Check one package
    *isInstalled{|package|
        ^this.prRunHelperWithCommand("-Q " ++ package, external: false) == 0
    }

    // Check array of packages
    *areInstalled{|packages|
        ^packages.every{|pack| this.isInstalled(pack) }
    }

    // Run aur helper command. External will run in seperate terminal, else using systemCmd
    *prRunHelperWithCommand{|command="-S supercollider", external=true|
        var helper = this.prFindAurHelper();

        ^if(helper.notNil, {
            command = "echo 'SuperCollider has spawned the following command:\n % % \n--------'; % %".format(
                helper,
                command,
                helper,
                command

            );

            if(external, { command.runInTerminal() }, { command.systemCmd() })
        })
    }

    // Find AUR helper on system. Pretty naive right now.
    *prFindAurHelper{
        var possibleCandidates = ["paru", "yay"];
        var result;

        // FIXME: If more than one helper is installed, it will always choose the last one found
        possibleCandidates.do{|cand|
            if("command -v %".format(cand).systemCmd == 0, {
                result = cand;
            })
        };

        if(result.isNil, {
            "%: Could not find AUR helper".format(this.name).error;
        }, {
            "%: Found AUR helper %".format(this.name, result).postln;
        });

        ^result
    }

}
