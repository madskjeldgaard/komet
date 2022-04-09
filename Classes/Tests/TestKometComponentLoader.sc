TestKometComponentLoader : KometTest {

    setUp {
        KometComponentLoader.clear();
        // this will be called before each test
    }

    tearDown {
        // this will be called after each test
        KometComponentLoader.clear();
    }

    test_componentsExist{
        var expectedComponents = [
            \grainshapes, \filters, \envelopes, \panners
        ];

        KometComponentLoader.loadAll();

        expectedComponents.do{|comp|
            this.assert(
                KometComponentLoader.exists(comp),
                "component name % exists".format(comp)
            )
        };

        this.assert(
            KometComponentLoader.all.size == expectedComponents.size,
            "Amount of components is as expected"
        )
    }

    test_path{
        var expectedPath=KometPath.path +/+ "components";
        this.assert(KometComponentLoader.componentsPath.fullPath == expectedPath.fullPath, "component path is as expected");
        this.assert(expectedPath.isFolder, "component path contains folder");
        this.assert(expectedPath.files.size > 0, "component path contains files");
    }

    test_loadsAll{
        this.assert(KometComponentLoader.loadAll(), "components loaded");
        this.assert(KometComponentLoader.all.collect{|comp| comp.items.size > 0}.every{|isTrue| isTrue}, "components not empty");
    }

}
