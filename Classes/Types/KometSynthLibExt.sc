/*
*
* This is not used directly, but should be subclassed in external packages to allow the Komet system to find them
*
*/
KometSynthLibExt{
    *thisPackage{
      ^Quarks.findClassPackage(this)
    }

    *thisPackageName{
        ^this.thisPackage().name
    }

    *thisPath{
        ^PathName(this.thisPackage().localPath)
    }

    *synths{
        ^(this.thisPath() +/+ "synths" +/+ "main")
    }

    *fx{
        ^(this.thisPath() +/+ "synths" +/+ "fx")
    }

    *parfx{
        ^(this.thisPath() +/+ "synths" +/+ "parallel")
    }

    *initClass{
        Class.initClassTree(KometSynthLib);
        if((this.class != KometSynthLibExt) && (this.class != Meta_KometSynthLibExt), {
            "Detected Kometsynthlib extension %".format(this.class.name).postln;
        });

        StartUp.add({
            KometSynthLib.files[\synths] = KometSynthLib.files[\synths] ++ this.synths().files;
            KometSynthLib.files[\fx] = KometSynthLib.files[\fx] ++ this.fx().files;
            KometSynthLib.files[\parfx] = KometSynthLib.files[\parfx] ++ this.parfx().folders.collect{|dir| dir.files}.flatten;
        })
    }
}
