KometSpecs {

    *initClass{
        StartUp.add{
            this.addSpecs();
        }
    }

    *addSpecs{
        var specs = [
            \lfofreq -> ControlSpec.new(minval: 0.0, maxval: 100.0, warp: 'exp', step: 0.0, default: 0.1);
        ];

        specs.asDict.keysValuesDo{|specName, spec|
            Log(\komet).debug("Adding spec % to global Spec.specs", specName);
            Spec.specs.put(specName, spec)
        }
    }

}
