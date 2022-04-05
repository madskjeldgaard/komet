/*
*
* Convenience function that allows one to play a pattern through an fx.
*
*/

MParFX {
    *new{|sourcePattern, fxDefName, fxArgPairs, releaseTime=10|
        var fxPairs = [fxDefName, \addAction, \addToTail] ++ fxArgPairs;

        if(sourcePattern.isNil, { "%: No source pattern supplied".format(this.class.name).error});
        if(fxDefName.isNil, { "%: No fx SynthDef name supplied".format(this.class.name).error});

        ^this.prmakePattern(sourcePattern, fxPairs, releaseTime)
    }

    *prmakePattern{|sourcePattern, fxPairs, releaseTime|
        ^Pgroup(
            Ppar([
                sourcePattern,
                // FX synth
                Pmono(
                    *fxPairs
                )
            ])
        ) <> (groupReleaseTime: releaseTime)
    }
}

// Same as above but wrapped in a Plambda so Plet and Pget can be used to share data between source and fx pattern.
MParFXShared : MParFX {
    *prmakePattern{|sourcePattern, fxPairs, releaseTime|
        ^Pgroup(
            Plambda(
                Ppar([
                    sourcePattern,
                    // FX synth
                    Pmono(
                        *fxPairs
                    )
                ])
            )
        ) <> (groupReleaseTime: releaseTime)

    }
}
