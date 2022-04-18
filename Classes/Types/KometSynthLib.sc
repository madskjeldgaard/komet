// TODO
KometSynthLib : LibraryBase {
    classvar <>global, <files;

    // TODO
    *get{

    }

    // TODO: Untested
    *guessCategory{|type, name|
        // If category is nil, try and see if we can guess it
        var category;
        var allAt = this.at(type);
        allAt.keysValuesDo{|key, dict|
            if(dict.keys.contains(name), {
                Log(\komet).debug("Guessed the category of %,%: %", name, type, key);
                category = key
            })
        }

        ^category
    }

    *initClass {
        global = this.new;
        files = MultiLevelIdentityDictionary.new;

        StartUp.add({
            var path = KometPath.path;
            files.put(\synths, (path +/+ "synths" +/+ "main").files);
            files.put(\faust, (path +/+ "faust").files.select{|ff| ff.extension == "dsp"});
            files.put(\fx, (path +/+ "synths" +/+ "fx").folders.collect{|dir| dir.files}.flatten);
            files.put(\parfx, (path +/+ "synths" +/+ "parallel").folders.collect{|dir| dir.files}.flatten);
        });
    }

  // TODO: Move
  // *argsFor{|basename, envType=\adsr, filterType=\dfm1|
  //   var sdname = this.get(basename, envType, filterType);
  //   ^SynthDescLib.at(sdname).controlNames
  // }
  //
  // // TODO: Move
  // *genPat{|basename, envType=\adsr, filterType=\dfm1|
  //   var sdname = this.get(basename, envType, filterType);
  //   KGenPat(sdname);
  // }

}
