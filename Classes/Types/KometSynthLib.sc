// TODO
KometSynthLib : LibraryBase {
    classvar <>global, <files;

    // TODO
    *get{

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
