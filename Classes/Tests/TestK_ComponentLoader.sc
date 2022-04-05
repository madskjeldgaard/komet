TestKLoad : UnitTest {

  setUp {
    KLoad.loadAll();
  }

  tearDown {
    KLoad.removeAll;
  }

  test_class_init{
    // Class state testing
    this.assert(KLoad.pkgPath.isFolder, "Valid pkg path");
    this.assert(KLoad.componentsPath.isFolder, "Valid components path");
    this.assert(KLoad.componentFiles.size > 0, "component files exist");
    this.assert(KLoad.all.size > 0 && KLoad.allLoaded, "Test Components loaded");
  }

  test_instance_init{
    // component test
    KLoad.all.do{|comp|
      var loaded = comp.load();

      this.assert(KLoad.exists(comp.name), "% exists in global dict".format(comp.name));
      this.assert(comp.path.notNil, "KLoad for % has pkg path".format(comp.name));
      this.assert(comp.path.isFile, "Valid components path for %".format(comp.name));
      this.assert(comp.isLoaded, "Loaded something for %".format(comp.name));
      this.assert(loaded.isKindOf(IdentityDictionary), "Loaded dict for % and it's a kind of dict".format(comp.name));
      this.assert(loaded.size > 0, "dict for % contains something".format(comp.name));
      this.assert(comp.keys.size > 0, "names for % contains something".format(comp.name));

    };

  }
}
