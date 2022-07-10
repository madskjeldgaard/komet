TestKometSynthLib : KometTest {
        setUp{

            KometSynthLib.clear();
            if(Komet.initialized.not, {
                Komet.start(2, true);
            });
        }

        tearDown{
            KometSynthLib.clear();
        }

        // TODO
        // test_synthdata{}

        test_fxdata{
            var condvar = CondVar.new();
            var func = {|in, freq| in * SinOsc.ar(freq)};
            var type = \fx;
            var category = \stereo;
            var basename = \testbase;
            var numChans = 2;
            var desc = "This is a description of a test synth";
            var specs = (freq: Spec.specs[\freq] );
            var sd = KometSynthFuncDef(
                basename,
                func,
                type,
                category,
                numChans,
                desc,
                specs,
            );
            var dataEntry, expectedKeys;
            condvar.waitFor(10, {
                KometFXFactory.initialized
            });
            sd.add();

            dataEntry = KometSynthLib.at(type, category, basename);

            expectedKeys = [
                \rawFunc,
                \builtFunc,
                \synthDefName,
                \synthDef,
                \kometSynthFuncDef,
            ];

            expectedKeys.do{|expectedKey|

                this.assert(dataEntry.at(expectedKey).notNil, "KometSynthFuncDef added to global KometSynthLib with data in " ++ expectedKey.asString);
            };

            this.assert(dataEntry.size == expectedKeys.size, "KometSynthFuncDef added to global KometSynthLib with correct size data in " ++ basename.asString);
        }

        test_add{
            var func = {|in, freq| in * SinOsc.ar(freq)};
            var type = \fx;
            var category = \stereo;
            var basename = \testbase;
            var numChans = 2;
            var desc = "This is a description of a test synth";
            var specs = (freq: Spec.specs[\freq] );
            var sd = KometSynthFuncDef(
                basename,
                func,
                type,
                category,
                numChans,
                desc,
                specs,
            );

            sd.add();
            this.assert( KometSynthLib.global.size == 1, "KometSynthFuncDef added to global KometSynthLib");
        }
    }
