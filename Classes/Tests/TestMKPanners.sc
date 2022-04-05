TestKPanners : UnitTest {
  var panners, algos;

  setUp {
    KLoad.loadAll();
    panners = KPanners();

    algos = [

      // Inputs, output, expected
      [1, 1, \mono2mono],
      [2, 1, \stereo2mono],

      [1, 2, \mono2stereo],
      [2, 2, \stereo2stereo],

      [1, 3, \mono2azimuth],
      [2, 3, \multi2azimuth],

      [1, \O1, \mono2hoaO1],
      [1, \O2, \mono2hoaO2],
      [1, \O3, \mono2hoaO3],
      [1, \O4, \mono2hoaO4],
      [1, \O5, \mono2hoaO5],
      [1, \O6, \mono2hoaO6],
      [1, \O7, \mono2hoaO7],

      [2, \O1, \stereo2hoaO1],
      [2, \O2, \stereo2hoaO2],
      [2, \O3, \stereo2hoaO3],
      [2, \O4, \stereo2hoaO4],
      [2, \O5, \stereo2hoaO5],
      [2, \O6, \stereo2hoaO6],
      [2, \O7, \stereo2hoaO7],
    ];

  }

  tearDown {
    // this will be called after each test

  }

  test_function_wrappers{
    algos.do{|algo|
      var ins = algo[0];
      var outs = algo[1];
      var expected = algo[2];
      var func = panners.getFunctionForWrapper(ins, outs);

      this.assert(func.isKindOf(Function), "function wrapper % is a kind of Function".format(expected));
      // this.assert({SynthDef.wrap(func, prependArgs: [Silent.ar()!1])}.asSynthDef.isNil.not, " function % may be turned into a synthdef".format(funcName))
    }
  }

  test_algoChoice {

    this.assert(
      algos.every{|i|
        var result = panners.choosePanAlgo(i[0], i[1]);

        this.debug("checking pan algo choice. Expected % from % in, % out\n".format(i[2], i[0], i[1]));
        result == i[2];
      }, "return correct algo");
    }
}
