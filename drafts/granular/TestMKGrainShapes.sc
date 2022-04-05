TestKGrainShapes : UnitTest {
  setUp{
      KLoad.loadAll();
      // KGrainShapes.new();
  }

  tearDown {
    KLoad.removeAll();
  }

  test_name{
    var c = KGrainShapes.new;
    this.assert(
      c.name.isNil.not,
      "component has name"
    );

    this.assert(
      KLoad.exists(c.name),
      "name corresponds to loaded component"
    );
  }

  test_grain_buffers{
    fork{
      var component;

      this.bootServer;
      component= KGrainShapes.new;
      component.buffers.keysValuesDo{|key, item|
        this.assert(item.class == Buffer);
      }
    }
    
  }

  test_grain_envelopes{
    fork{
      var component;

      this.bootServer;

      component = KGrainShapes.new;
      component.items.items.keysValuesDo{|key, item|
        this.assert(item.class == Env, "function wrapper % is a envelope".format(key));
      }
    }
  }
}
