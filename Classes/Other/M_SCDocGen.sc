/*

this will auto generate a help file for a class. If no outputfolder path is given, it will try and guess the output folder based on the class's path.

*/
M_SCDocGen{
    *method2scdoc{|meth|
        var outString = "";
        var argString = "";
        var args = meth.argNames.do{|arggg|
            if(arggg.asSymbol != \this, {
                argString = argString ++ "ARGUMENT::%\n".format(arggg)
            })
        };
        outString = "METHOD::%\n%\n".format(meth.name, argString);

        ^outString

    }

    *new{|inclass, outfolder|
        var pathToHelpFile = if(outfolder.isNil,{
            var thefolder = PathName(
                inclass.filenameSymbol.asString
            )
            .parentPath.asPathName
            .parentPath.asPathName
            .pathOnly
            +/+ "HelpSource"
            +/+ "Classes";

            if(thefolder.isFolder.not, {
                "%: Folder % does not exist. Outputting to current dir instead.".format(this.name, pathToHelpFile)
            }, {
                thefolder
            });
        }, {
            outfolder
        });
        var class = inclass;
        var name = class.name;
        var classMethods = class.class.methods;
        var classMethodHelpString = "";
        var methods = class.methods;
        var methodsHelpString = "";
        var helpFileString, filename, file;

        if(methods.size > 0, {
            methodsHelpString = "INSTANCEMETHODS::\n";
            methods.do{|meth|
                methodsHelpString = methodsHelpString ++ this.method2scdoc(meth)
            };
        });

        if(classMethods.size > 0, {
            classMethodHelpString = "CLASSMETHODS::\n";
            classMethods.do{|meth|
                classMethodHelpString = classMethodHelpString ++ this.method2scdoc(meth)
            };
        });
        helpFileString =
        "TITLE::%
SUMMARY::A class
CATEGORIES::TODO
RELATED::Classes/Class

DESCRIPTION::
Short description... TODO

%

%

EXAMPLES::

CODE::
// TODO
::".format(name, classMethodHelpString, methodsHelpString.postln);

    filename = inclass.asString ++ ".schelp";
    filename = (pathToHelpFile +/+ filename);
    "Making scdoc file %".format(filename).postln;
    file= File.open(pathName: filename, mode:"w");
    file.write(helpFileString);
    file.close;

    }
}
