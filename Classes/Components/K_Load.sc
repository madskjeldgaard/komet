/*
 *
 * Used for loading components
 *
 */
 KLoad {
   classvar <all, <pkgPath, <componentsPath, <componentFiles, <allLoaded;
   var <path, <items, <name, <isLoaded;

   *initClass{

     allLoaded = false;

     Class.initClassTree(KometSynthFactory);
     Class.initClassTree(KometFXFactory);

     StartUp.add{
       pkgPath = KometPath.path;
       componentsPath = pkgPath +/+ "components";
       componentFiles = componentsPath.files;
     }
   }

   *new { | componentFile |
     ^super.new.init(componentFile)
   }

   *at{|key|
     ^all[key]
   }

   at{|key|
     ^items[key]
   }

   *loadAll{
    var didLoad = [];
    all = componentFiles.collect{|file|
        // Only continue loading if nothing has failed
        if(didLoad.every{|isTrue| isTrue}, {
            var kloader = this.new(file.fileName);
            didLoad = didLoad.add(kloader.load());
            [kloader.name -> kloader]
        })
    }.flatten.asDict;
     allLoaded = didLoad.every{|isTrue| isTrue } && didLoad.size == componentFiles.size;
     ^allLoaded
   }

   *removeAll{
     all = IdentityDictionary.new();
   }

   *exists{|componentName|
     if(all.size == 0, { "%: all dict is 0".format(this.asString).error; ^nil});
     ^all.at(componentName.asSymbol).isNil.not
   }

   init { | componentFile |
     isLoaded = false;
     path = componentsPath +/+ componentFile;
     name = path.fileNameWithoutExtension.asSymbol;
   }

   // Returns whether or not it loaded
   load{
     isLoaded = true;
     items = path.fullPath.load;
     ^items.notNil;
   }

   keys{
     ^items.keys
   }

 }
