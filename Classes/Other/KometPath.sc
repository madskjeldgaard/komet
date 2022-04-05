KometPath{
    classvar <fullPath, <pkgName='komet';

    *initClass{
        StartUp.add({
            fullPath = PathName(Main.packages.asDict.at(pkgName));
        })
    }
}
