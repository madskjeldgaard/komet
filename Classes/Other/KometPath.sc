KometPath{
    classvar <fullPath, <path, <pkgName='komet', <sndPath, <faustFilesPath;

    *initClass{
        StartUp.add({
            path = PathName(Main.packages.asDict.at(pkgName));
            fullPath = path.fullPath;
            sndPath = path +/+ "snd";
            faustFilesPath = path +/+ "faust";
        })
    }
}
