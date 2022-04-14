KometEvents{

  *initClass{
    Class.initClassTree(Event);
    StartUp.add({
      this.addEventTypes
    })
  }

  *addEventTypes{

    // This is an expanded version of \note but where you dont set the \instrument key but rather the base, env type and filter used in KS
    Event.addEventType(\k, { |server|

      ~base = ~base ? \complex;
      ~env = ~env ? \adsr;
      ~filter = ~filter ? \vadim;
      ~instrument = KometSynthFactory.get(~base, ~env, ~filter);
      if(~instrument.isNil, { "%: instrument is nil".format(this.name).error; ~instrument = \default});

      // This is basically a bunch of aliases and default settings for the envelopes
      // If nothing specific is set in eg the filter and pitch envelopes, the main aka vca envelope's values are used
      ~atk = ~atk ? 0.25;
      ~rel = ~rel ? 0.25;
      ~dec = ~dec ? 0.25;
      ~sus = ~sus ? 0.9;
      ~curve = ~curve ? (-5.0);

      ~attack = ~attack ? ~atk;
      ~release = ~release ? ~rel;
      ~decay = ~decay ? ~dec;
      ~sustainLevel = ~sustainLevel ? ~sus;
      ~envcurve = ~envcurve ? ~curve;

      ~vcaattack = ~vcaattack  ? ~attack;
      ~vcarelease = ~vcarelease  ? ~release;
      ~vcadecay = ~vcadecay  ? ~decay;
      ~vcasustainLevel = ~vcasustainLevel  ? ~sustainLevel;
      ~vcaenvcurve = ~vcaenvcurve ? ~envcurve;

      ~pitchattack = ~pitchattack ? ~vcaattack;
      ~pitchrelease = ~pitchrelease ? ~vcarelease;
      ~pitchdecay = ~pitchdecay ? ~vcadecay;
      ~pitchsustainLevel = ~pitchsustainLevel ? ~vcasustainLevel;
      ~pitchenvcurve = ~pitchenvcurve ? ~envcurve;

      ~fattack = ~fattack ? ~vcaattack;
      ~frelease = ~frelease ? ~vcarelease;
      ~fdecay = ~fdecay ? ~vcadecay;
      ~fsustainLevel = ~fsustainLevel ? ~vcasustainLevel;
      ~fenvcurve = ~fenvcurve ? ~envcurve;

      // Filter specific stuff
      ~res = ~res ? 0.1;
      ~resonance = ~resonance ? ~res;
      ~fresonance = ~fresonance ? ~resonance;

      ~cutoff = ~cutoff ? 15000.0;
      ~fcutoff = ~fcutoff ? ~cutoff;

      // Panning and spatial
      ~angle = ~pan ? 0;

      // Inherit from normal note event
      ~type = \note;
      currentEnvironment.play;
    });

    Event.addEventType(\kometchain, {
        if(~chain.isNil, {
            Log(\komet).error("No chain specified");
        }, {
            var rejectKeys = [\type, \node, \chain];
            var args = currentEnvironment
            .collect{|key, value| [value,key] }
            .reject{|key, value| rejectKeys.includes(key[0])}
            .asArray.flatten;

            ~type = \set;
            ~node = ~chain.group;

            // KometMainChain's "group" is just a raw group number, while other chain types are Group
            if(~node.isKindOf(Group), {
                ~node.set(*args)
            }, {
                ~node.asGroup.set(*args)
            })
        })
    });
  }

}
