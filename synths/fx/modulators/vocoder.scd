(
[8, 16, 32].do{|numbands|
    var name = "vocoder%bands".format(numbands).asSymbol;
    K_FX.addFX(
        basename: name,
        synthfunc: {|numChannels|
            {|in|

                var lagTime = \lagTime.kr(1);
                Array.fill(numChannels, {|chanNum|
                    var sig = in[chanNum];

                    var freq = \freq.ar(100)..klag(lagTime);
                    var oscillator = Select.ar(\oscType.kr(0), array:[
                        SawDPW.ar(freq),
                        PulseDPW.ar(freq),
                    ]);

                    var carrier = SelectX.ar(
                        // Thanks Nathan!
                        (ZeroCrossing.ar(sig).lag(0.05) > 5000).lag(0.05), [
                            oscillator,
                            PinkNoise.ar()
                        ]
                    );

                    var bandrq = \rq.kr(0.05);

                    sig = Array.fill(numbands, {|bandNum|
                        var bandfreq = bandNum.linexp(0,numbands-1, \minFreq.ir(100), \maxFreq.ir(8000));
                        var filtered = BPF.ar(in:sig, freq:bandfreq, rq:bandrq, mul:1.0, add:0.0);
                        // var filtered = VadimFilter.ar(input:sig, freq:bandfreq, resonance:bandres, type:3);

                        var carrierFiltered = BPF.ar(carrier, bandfreq, bandrq);
                        // var osc = VadimFilter.ar(input:inputSig, freq:bandfreq, resonance:bandres, type:3);
                        var thisGain = "bandGain%".format(bandNum+1).asSymbol.kr(numbands.reciprocal);
                        var atk = "bandAttack%".format(bandNum+1).asSymbol.kr(0.01);
                        var rel = "bandRelease%".format(bandNum+1).asSymbol.kr(0.05);
                        carrierFiltered * thisGain * Amplitude.ar(in:filtered, attackTime:atk, releaseTime:rel) * bandrq.reciprocal
                    });

                    sig = sig.sum * 30.dbamp;

                    SafetyLimiter.ar(sig)

                })
            }
        },
        type: \channelized,
        check: { \SafetyLimiter.asClass.notNil },
        specs:
        (
            oscType: [0,1],
            rq: [0.001, 0.5],
            freq: Spec.specs[\freq],
            minFreq: Spec.specs[\freq],
            maxFreq: Spec.specs[\freq],
        ) ++ numbands.collect{|bandNum|
            bandNum = bandNum+1;
            [
                "bandGain%".format(bandNum).asSymbol -> Spec.specs[\amp],
                "bandAttack%".format(bandNum).asSymbol -> [0.00001, 1.0, \exp],
                "bandRelease%".format(bandNum).asSymbol -> [0.00001, 1.0, \exp],
            ]
        }.flatten,
    );
}
)
