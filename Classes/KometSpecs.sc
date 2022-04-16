KometSpecs {
    classvar <specs;

    *initClass{
        StartUp.add{
            this.addSpecs();
        }
    }

    *addSpecs{
        specs = (
            lagTime: ControlSpec.new(
                minval: 0.0, maxval: 20.0, warp: 'exp', step: 0.0, default: 1.0
            ),
            spread: ControlSpec.new(
                minval: 0.0, maxval: 1.0, warp: 'lin', step: 0.0, default: 0.0
            ),
            lfofreq: ControlSpec.new(
                minval: 0.0, maxval: 100.0, warp: 'exp', step: 0.0, default: 0.1
            ),
            freqOffset: ControlSpec.new(
                minval: 0.0, maxval: 100.0, warp: 'exp', step: 0.0, default: 0.0
            ),
            attack: [0.00001,100.0],
            release: [0.00001,100.0],
            decay: [0.00001,100.0],
            envcurve: [-10.0,10.0],
            sustainLevel: [0.0,1.0]
        ).collect{|spec| spec.asSpec };

        specs.keysValuesDo{|specName, spec|
            Log(\komet).debug("Adding spec % to global Spec.specs", specName);
            Spec.specs.put(specName, spec)
        }
    }

}
