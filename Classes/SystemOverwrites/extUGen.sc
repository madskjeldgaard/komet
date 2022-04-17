 + UGen {
     kWithWow{|wowAmount=0.0, wowMinFreq=0.01, wowMaxFreq=10.0|
         var wow = LFDNoise3.ar(
             wowAmount.linexp(0.0,1.0,max(wowMinFreq, 0.00001),wowMaxFreq)
         ).range(1.0 + wowAmount, 1.0 - wowAmount);

         ^(this * wow)

     }

     kWithPitchEnv{|dur, pitchenvAmount, envType=\adsr|
        var pitchEnv = KEnvelopes().getWrap(envType, "pitch", "", dur, 0);
        ^pitchEnv.linlin(
            0.0,
            1.0,
            this + (this * pitchenvAmount),
            this - (this * pitchenvAmount)
        );
     }
 }
