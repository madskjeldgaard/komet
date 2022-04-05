TestKFilters : UnitTest {
  setUp{
    KLoad.loadAll();
  }

  tearDown {
    KLoad.removeAll();
    Ndef.all.clear;
  }

  test_name{
    var c = KFilters.new;
    this.assert(
      c.name.isNil.not,
      "component has name"
    );

    this.assert(
      KLoad.exists(c.name),
      "name corresponds to loaded component"
    );
  }

  test_function_wrappers{
    var component = KFilters.new;
    var functionNames = KLoad.at(component.name).keys;
    // this.debug("---" ++ component.name.toUpper ++ "---" ++ "\n");

    functionNames.do{|funcName|
      var func = component.getFunctionForWrapper(funcName);

      this.debug("checking function wrapper for %\n".format(funcName));
      this.assert(func.isKindOf(Function), "function wrapper % is a kind of Function".format(funcName));
      // this.assert({SynthDef.wrap(func, prependArgs: [Silent.ar()!1])}.asSynthDef.isNil.not, " function % may be turned into a synthdef".format(funcName))
    }
  }
}
