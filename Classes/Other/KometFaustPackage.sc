/*

This class takes a folder containing faust files and compiles them to SuperCollider plugins including SuperNova plugins.

It places them in the user extensions folder in a folder defined in the installTargetFolder argument.

*/

KometFaustPackage : AbstractFaustPackage{
    // FIXME: This is a hack to fix a problem with Quarks that don't recurse submodules currently
    *checkSubmodules{
        // https://stackoverflow.com/questions/12641469/list-submodules-in-a-git-repository
        var cmd;
        var submodulePaths;
        // Check if folders are empty
        var submodulesPulled;
        cmd = "cd %; git config --file .gitmodules --get-regexp path | awk '{ print $2 }'".format(KometPath.fullPath);

        Log(\komet).debug(cmd);

        submodulePaths = cmd.unixCmdGetStdOutLines;

        submodulesPulled = submodulePaths.collect{|subpath|
            var thispath = (KometPath.fullPath +/+ subpath.asPathName);
            Log(\komet).debug("Checking if submodule in path % is pulled", thispath);
            if(subpath.notNil, {
                thispath.files.size > 0
            })
        }.every{|bool| bool };

        ^submodulesPulled
    }

    *pullSubmodules{
        var cmd = "cd %; git submodule update --init --recursive".format(KometPath.fullPath);
        Log(\komet).debug(cmd);
        cmd.unixCmdGetStdOut;
    }

    *initClass{
        Class.initClassTree(KometPath);
        Class.initClassTree(Log);

        StartUp.add{
            if(this.checkSubmodules().not, {
                Log(\komet).info("Pulling submodules for komet faust plugins");
                this.pullSubmodules()
            });
        };

        this.autoCompileAtStartup()
    }
}
