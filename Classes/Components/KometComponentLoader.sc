/*
 *
 * Used for loading components
 *
 * TODO: Rewrite to use Singleton in KometComponentLoader(\componentName) style
 */
 KometComponentLoader {
   classvar <all, <componentsPath, <componentFiles, <allLoaded;
   var <path, <items, <name, <isLoaded;

   *clear{
       this.removeAll();

       allLoaded = false;
       all = nil;

       // TODO
       // this.instances.do{|inst|
       //     inst.clear();
       // }
   }

   clear{
       items = [];
       isLoaded = false;
   }

   *initClass{

     allLoaded = false;

     Class.initClassTree(KometSynthFactory);
     Class.initClassTree(KometFXFactory);

     StartUp.add{
       var pkgPath = KometPath.path;
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

     Log(\komet).debug("Initializing component loader for %", name);
   }

   // Returns whether or not it loaded
   load{
       Log(\komet).info("Loading component file %", name);
       isLoaded = true;
       items = path.fullPath.load();
       ^items.notNil && items.isKindOf(Dictionary)
   }

   keys{
     ^items.keys
   }

 }
