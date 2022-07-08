// TODO
KometPreset {
    classvar <resourcePath;

    *initClass{
        StartUp.add({
            Class.initClassTree(Komet);

            resourcePath =  PathName(Platform.userAppSupportDir +/+ "komet");

            resourcePath.isFolder.not.if{
                Log(\komet).info("Resource folder not found. Creating it now");
                File.mkdir(pathName:resourcePath.fullPath)
            };

            Komet.resourcePath = resourcePath;

            Archive.at(\komet).isNil.if{
                Log(\komet).info("Archive for komet doesn't exist. Creating it now");
                Archive.put(\komet, MultiLevelIdentityDictionary.new());
            }
        })

    }

}
