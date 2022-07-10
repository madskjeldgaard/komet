// TODO: Test \kometchain
TestKometEvents : KometTest{

    setUp {
        var condvar = CondVar.new();
        KometSynthFactory.initialized.not.if{
            KometSynthFactory.new(numChannelsOut:2, rebuild:false);
        };

        condvar.waitFor(10, {
            KometSynthFactory.initialized
        })
    }

    test_k_envelope_equivalence{
        var event = (type:\k).play;
        this.assert(
            event[\atk] == event[\attack] &&
            event[\atk]  == event[\vcaattack] &&
            event[\atk] == event[\pitchattack] &&
            event[\atk] == event[\fattack],
            "attacks are equivalent"
        );

        this.assert(
            event[\rel] == event[\release] &&
            event[\rel] == event[\vcarelease] &&
            event[\rel] == event[\pitchrelease] &&
            event[\rel] == event[\frelease],
            "releases are equivalent"
        );
        this.assert(
            event[\dec] == event[\decay] &&
            event[\dec]  == event[\vcadecay] &&
            event[\dec] == event[\pitchdecay] &&
            event[\dec] == event[\fdecay],
            "decays are equivalent"
        );
        this.assert(
            event[\sus] == event[\sustainlevel] &&
            event[\sus] == event[\vcasustainlevel] &&
            event[\sus] == event[\pitchsustainlevel] &&
            event[\sus] == event[\fsustainlevel],
            "sustainlevels are equivalent"
        );
        this.assert(
            event[\curve] == event[\envcurve] &&
            event[\curve]  == event[\vcaenvcurve] &&
            event[\curve] == event[\pitchenvcurve] &&
            event[\curve] == event[\fenvcurve],
            "envCurves are equivalent"
        );
    }

    test_k_envelope_propagation_attack{
        var event = (type:\k, atk: 0.5, vcaattack: 0.9, pitchattack: 0.33, fattack:0.29).play;
        this.assert(
            event[\atk]  == 0.5 &&
            event[\attack] == 0.5 &&
            event[\vcaattack] == 0.9 &&
            event[\pitchattack] == 0.33 &&
            event[\fattack] == 0.29,
            "attacks specified for components"
        );
    }
    test_k_envelope_propagation_decay{
        var event = (type:\k, dec: 0.5, vcadecay: 0.9, pitchdecay: 0.33, fdecay:0.29).play;
        this.assert(
            event[\dec]  == 0.5 &&
            event[\decay] == 0.5 &&
            event[\vcadecay] == 0.9 &&
            event[\pitchdecay] == 0.33 &&
            event[\fdecay] == 0.29,
            "decays specified for components"
        );
    }

    test_k_envelope_propagation_release{
        var event = (type:\k, rel: 0.5, vcarelease: 0.9, pitchrelease: 0.33, frelease:0.29).play;
        this.assert(
            event[\rel]  == 0.5 &&
            event[\release] == 0.5 &&
            event[\vcarelease] == 0.9 &&
            event[\pitchrelease] == 0.33 &&
            event[\frelease] == 0.29,
            "releases specified for components"
        );
    }

    test_k_envelope_propagation_sustainlevel{
        var event = (type:\k, sus: 0.5, vcasustainlevel: 0.9, pitchsustainlevel: 0.33, fsustainlevel:0.29).play;
        this.assert(
            event[\sus]  == 0.5 &&
            event[\sustainlevel] == 0.5 &&
            event[\vcasustainlevel] == 0.9 &&
            event[\pitchsustainlevel] == 0.33 &&
            event[\fsustainlevel] == 0.29,
            "sustainlevels specified for components"
        );
    }

    test_k_envelope_propagation_envcurve{
        var event = (type:\k, curve: 0.5, vcaenvcurve: 0.9, pitchenvcurve: 0.33, fenvcurve:0.29).play;
        this.assert(
            event[\curve]  == 0.5 &&
            event[\envcurve] == 0.5 &&
            event[\vcaenvcurve] == 0.9 &&
            event[\pitchenvcurve] == 0.33 &&
            event[\fenvcurve] == 0.29,
            "envcurves specified for components"
        );
    }

    test_k_filter_equivalence{
        var event = (type:\k).play;
        this.assert(
            event[\res] == event[\resonance] &&
            event[\res] == event[\fresonance],
            "resonances are equivalent"
        );
        this.assert( event[\cutoff] == event[\fcutoff], "cutoffs are equivalent");
    }
}
