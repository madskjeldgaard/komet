TestKometChains : KometTest{
    var condvar;

    setUp{
        var numChannels = 2;

        condvar = CondVar.new();

        // forkIfNeeded{
        // if(Komet.initialized.not, {
        //     Komet.start(2, true);
        // });
        KometFXFactory.initialized.not.if{
            KometFXFactory.new(KometChannels(2), true);
        };

        // Server.local.sync;

        // KometMainChain(\main, [
        //     KometFXItem.new(\eq3, \channelized, []),
        // ], numChannels, 1);
        // KometMainChain(\main).clear();

        this.bootServer(Server.local);
        // }
    }

    tearDown{
        var numChannels = 2;
        // KometMainChain(\main).clear();
        KometMainChain(\main, [], numChannels, 1)

    }

    test_argumentpersistence{
        fork{
            var cond = CondVar.new();
            var args;
            var numChannels = 2;
            var setArgs = [];
            var lowlevel = 3.5;
            var initArgs = [\lowlevel, lowlevel];

            // fork{ loop{ 1.0.wait; if(KometSynthLib.files[\fx].notNil, { condvar.signalOne;  "done".postln; break; })}};
            condvar.waitFor(10, {KometSynthLib.global[\fx].notNil && KometFXFactory.initialized && Server.local.hasBooted});

            Server.local.sync;

            KometMainChain(\main, [
                KometFXItem.new(\eq3, \channelized, initArgs),
            ], numChannels, 1);

            Server.local.sync;

            // Initial args
            KometMainChain(\main).synthAt(0).get(\lowlevel, {|val|
                this.assert(lowlevel == val, "Synth has initial args", details: [\expected, lowlevel, \got, val]);
                cond.signalOne;
            });

            this.debug("Waiting for KometMainChain to return value\n");
            cond.waitFor(10);

            // Cmd period
            thisProcess.hardStop(); Server.local.sync;
            1.wait; // Wait is necessary for the node to respawn before the following code is run:
            args = KometMainChain(\main).argsAt(0);
            this.assert(initArgs == args, "Initial args are set");

            Server.local.sync;
            KometMainChain(\main).synthAt(0).get(\lowlevel, {|val|
                this.assert(lowlevel == val, "Synth has initial args after cmd period", details: [\expected, lowlevel, \got, val]);
                cond.signalOne;
            });

            this.debug("Waiting for KometMainChain to return value\n");
            cond.waitFor(10);

            // Set args again
            lowlevel = (-10.0);
            setArgs = [\lowlevel, lowlevel];
            KometMainChain(\main).setSynthAt( *([0] ++ setArgs));
            args = KometMainChain(\main).argsAt(0);
            this.assert(setArgs == args, "Setting args changes data");

            KometMainChain(\main).synthAt(0).get(\lowlevel, {|val|
                this.assert(lowlevel == val, "Synth has correct args after being set manually", details: [\expected, lowlevel, \got, val]);
                cond.signalOne;
            });

            this.debug("Waiting for KometMainChain to return value\n");
            cond.waitFor(10);

            thisProcess.hardStop(); Server.local.sync; 1.wait;
            this.assert(setArgs == args, "Newly set args persist after hardstop");

            KometMainChain(\main).synthAt(0).get(\lowlevel, {|val|
                this.assert(lowlevel == val, "Synth has correct args after being set manually and cmd period being called", details: [\expected, lowlevel, \got, val]);
                cond.signalOne;
            });

            this.debug("Waiting for KometMainChain to return value\n");
            cond.waitFor(10);

        }
    }

}
