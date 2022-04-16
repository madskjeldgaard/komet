// TODO
KometParFXFactory : AbstractKometFactory {

    // TODO
    *addParallel2{|basename1, basename2, type|
        var basename = "par2_" ++ basename1.asString ++ "_" ++ basename2.asString;
        var synthDefs = [this.getFunc(basename1, type), this.getFunc(basename2, type)];

        var func = {|sig, crossoverFreq=500|
            var bands =  Krossover2.ar(sig, crossoverFreq);

            sig = Array.fill(2, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.prAddDef(basename, func, type)
    }

    // TODO untested
    *addParallel4{|basename1, basename2, basename3, basename4, type|
        // FIXME: Because I'm a lazy fucking idiot:
        var basename = "par4_" ++ basename1.asString ++ "_" ++ basename2.asString ++ "_" ++ basename3.asString ++ "_" ++ basename4.asString;
        var synthDefs = [this.getFunc(basename1, type), this.getFunc(basename2, type),this.getFunc(basename3, type),this.getFunc(basename4, type)];

        var func = {|sig, crossoverFreq1=500, crossoverFreq2=1250, crossoverFreq3=2500|
            var bands =  Krossover4.ar(sig, crossoverFreq1, crossoverFreq2, crossoverFreq3);

            sig = Array.fill(4, {|i|
                SynthDef.wrap(synthDefs[i], prependArgs: [bands[i]])
            });

            sig = Mix.ar(sig);

            sig
        };

        this.prAddDef(basename, func, type)
    }

}
