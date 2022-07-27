/*
*
* A simple project generator
*
*/
KometProject{
    var name;

    *new{|path, projectName|
        ^super.new.init(path, projectName)
    }

    init{|path, projectName|
        name = projectName;
        if(File.exists(pathName:PathName(path +/+ name).fullPath), {
            Log(\komet).error(path.asString ++ " already exists... aborting");
        }, {
            var pathName = PathName.new(path +/+ name);

            // Setup folders
            File.mkdir(pathName.fullPath);
            File.mkdir((pathName +/+ "samples").fullPath);
            File.mkdir((pathName +/+ "fxchains").fullPath);
            File.mkdir((pathName +/+ "patterns").fullPath);

            // Create init file
            File.use((pathName +/+ "init.scd").fullPath, "w", { |f|
                f.write(this.prInitFileContents(pathName))
            }).close;

            // Create readme
            File.use((pathName +/+ "README.md").fullPath, "w", { |f|
                f.write("# " ++ name)
            }).close;

            // Create quark file

            File.use((pathName +/+ (name.toLower() ++ ".quark")).fullPath, "w", { |f|
                f.write("( name: %, dependencies: [\"https://github.com/madskjeldgaard/komet\"])".format(name))
            }).close;

            this.prRunGitCommands();
        })
    }

    prInitFileContents{|pathName|
        var string = "";

        string = string ++ "/**************************\nKomet Project: %. Generated % \n**************************/\n".format(name, Date.getDate);
        string = string ++ "(\n";
        string = string ++ "Komet.start(
numChannelsOut: KometConfig.config[\\numChannelsOut] ? 2,
build: KometConfig.config[\\build] ? false,
openGuiAfterInit:KometConfig.config[\\openGuiAfterInit] ? true,
action:{
    forkIfNeeded{
        Server.local.sync;
        ~buffers = BufFiles.new(Server.local, \"samples\".asRelativePath);
    }
},
loglevel:\\info
)";
        string = string ++ "\n)";

        ^string
    }

    prRunGitCommands{
        // TODO: Git LFS must be installed for this
        var gitcommands = ["git", "init", "&&", "git", "lfs", "install"].join(" ");
        gitcommands.systemCmd();
    }
}
