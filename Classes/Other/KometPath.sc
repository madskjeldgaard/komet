KometPath{
    classvar <fullPath, <path, <pkgName='komet';

    *initClass{
        StartUp.add({
            path = PathName(Main.packages.asDict.at(pkgName));
            fullPath = path.fullPath;
        })
    }
}
