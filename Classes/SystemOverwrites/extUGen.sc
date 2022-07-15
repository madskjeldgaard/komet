 + UGen {

     // Add lag to a signal
     klag{ arg time=0.1;
         ^Lag.multiNew(this.rate, this, time)
     }

     // Add modulation to a signal
     kWithMod{|modFreq=1, modAmount=1, modShape(KPanShape.noise)|
         var r = switch (this.rate,
             'audio', { 'ar' },
             'control', { 'kr' },
             'scalar', { 'ir' }
         );

         ^KAutoPan.new1(r, this, modFreq, modAmount, modShape)
     }

     // Add wow/drift to a signal
     kWithWow{|wowAmount=0.0, wowMinFreq=0.01, wowMaxFreq=10.0|
         var wow = LFDNoise3.ar(
             wowAmount.linexp(0.0,1.0,max(wowMinFreq, 0.00001),wowMaxFreq)
         ).range(1.0 + wowAmount, 1.0 - wowAmount);

         ^(this * wow)

     }

     // Add pitch envelope to a signal
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
