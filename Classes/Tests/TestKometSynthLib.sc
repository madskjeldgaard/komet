TestKometSynthLib : KometTest {
        setUp{
            KometSynthLib.clear();
        }

        tearDown{
            KometSynthLib.clear();
        }

        // TODO
        // test_synthdata{}

        test_fxdata{
            var func = {|in, freq| in * SinOsc.ar(freq)};
            var type = \fx;
            var category = \testcategory;
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
            var category = \testcategory;
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
