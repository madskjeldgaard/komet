TestM : UnitTest {

  test_get_returns_symbol{
    fork{
      var synthName;
      this.bootServer();
      this.checkIfInit();
      // @TODO make this automatic in it's choice
      synthName = M.get(\zosc, \adsr, \dfm1);
      this.assert(synthName.class == Symbol)
    }
  }

  test_get_args{
    fork{
      var args;
      this.bootServer();
      this.checkIfInit();
      // @TODO make this automatic in it's choice
      args = M.argsFor(\zosc, \adsr, \dfm1);
      this.assert(args.class == Array);
      this.assert(args.size > 0);
    }
  }

  checkIfInit{
    if(Main.scVersionMinor < 12, {
      "This test needs CondVar which came out in 3.12!!!".error
    }, {
      var condition = CondVar();
      var timeOut = 30;
      condition.waitFor(timeOut,{ M.initialized } );
      "M has been initialized and can be tested now".postln;
    });
  }

  setUp {
    fork{
      M();
      this.bootServer;
      this.checkIfInit();
    }
  }
  tearDown {
    // @TODO
  }
}
