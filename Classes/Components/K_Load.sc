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

     Class.initClassTree(K);
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
     all = componentFiles.collect{|file|
       var kloader = this.new(file.fileName);
       kloader.load();
       [kloader.name -> kloader]
     }.flatten.asDict;
     allLoaded = true;
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

   load{
     isLoaded = true;
     items = path.fullPath.load;
     ^items;
   }

   keys{
     ^items.keys
   }

 }
