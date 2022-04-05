/*
TestKAutoPan : UnitTest {

	var server;

	setUp {
		server = Server(this.class.name);
        server.options.maxSynthDefs_(20000);
	}

    tearDown {
      server.quit;
      server.remove;
    }

    // test_pan_bounds {
    //   var condvar = CondVar.new();
    //   // var condition = Condition.new;

    //   var func = {
    //     KAutoPan.ar(pan:(0.9), panFreq:1, autopan:1, panShape:0.0);
    //   };

    //   server.bootSync;

    //   func.loadToFloatArray(1, server, { |data|
    //     this.assert(data.maxItem < 1.0, "Pan does not go beyond 1.0", true);
    //     this.assert(data.minItem > (-1.0), "Pan does not go below -1.0", true);

    //     condvar.signalOne;
    //   });

    //   condvar.waitFor(1);
    // }

    test_static_pan_value_equivalence {
      var condvar = CondVar.new();

      // Positive pan values
      var funcs = [0, 0.5, 1.0].collect{|panval|
        [panval,
          {
            DC.ar(panval) -
            KAutoPan.ar(pan:(panval), panFreq:1, autopan:0, panShape:0.0);
          }
        ]
      };

      // Negative pan values
      funcs ++ [(-1.0),(-0.5), (-0.25)].collect{|panval|
          [panval,
            {
              DC.ar(panval) +
              KAutoPan.ar(pan:(panval), panFreq:1, autopan:0, panShape:1.0);
            }
          ]
      };

      server.bootSync;

      funcs.do{|item|
        var val = item[0];
        var func = item[1];
        func.loadToFloatArray(1, server, { |data|
          this.assertArrayFloatEquals(data, 0.0, "Static pan of KAutoPan: " ++ val.asString , within: 0.001, report: true);

          condvar.signalOne;
          // condition.unhang;
        });
      };

      condvar.waitFor(1);
      // condition.hang;
    }

}
*/
