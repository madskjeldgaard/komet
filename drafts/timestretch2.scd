// Based on TimeStretch: https://github.com/spluta/TimeStretch
(
s.waitForBoot{
    var numSplits = 3;
    var fftMax = 65536;
    var sampleRate = s.sampleRate;
    var filterVals = TimeStretch2.getFilterVals(sampleRate, numSplits);
    var fftVals = TimeStretch2.getFFTVals(filterVals, fftMax);

    var timeStretchBand = {|bufnum, fftSize = 8192, fftMax = 65536, hiPass = 0.125, lowPass=0.25, stretch = 10, startPos=0|

    var trigPeriod, sig, chain, trig, trig1, trig2, pos, jump, trigEnv, fftDelay, bigEnv, window0, window1, rVal, correlation, sum, localIn, rVal1, rVal2, outSig, analSig;

    trigPeriod = (fftSize/SampleRate.ir);
    trig = Impulse.ar(2/trigPeriod);

    trig1 = PulseDivider.ar(trig, 2, 1);
    trig2 = PulseDivider.ar(trig, 2, 0);

    startPos = (startPos%1);
    pos = Line.ar(startPos*BufFrames.kr(bufnum), BufFrames.kr(bufnum), BufDur.kr(bufnum)*stretch*(1-startPos));

    jump = fftSize/stretch/2;
    pos = [pos, pos + jump];

    sig = PlayBuf.ar(1, bufnum, 1, trig1, pos, 1)*SinOsc.ar(1/(2*trigPeriod)).abs*0.5;

    sig = sig.collect({ |item, i|
        chain = FFT(LocalBuf(fftSize), item, hop: 1.0, wintype: 0);
        chain = PV_Diffuser(chain, 1-trig1);
        chain = PV_BrickWall(chain, hiPass);
        chain = PV_BrickWall(chain, lowPass-1);
        item = IFFT(chain, wintype: -1);
    }).flatten;

    //delay the signal so that all fftSizes line up (the will already be delayed by the fftSize
    sig = DelayN.ar(sig, (3*fftMax/2)-(3*fftSize/2)+BlockSize.ir/SampleRate.ir, fftMax-fftSize+BlockSize.ir/SampleRate.ir);

    sig[1] = DelayN.ar(sig[1], trigPeriod/2, trigPeriod/2);

    sum = RunningSuK.ar((sig[0]*sig[1]), fftSize/2)/RunningSuK.ar((sig[0]*sig[0]), fftSize/2);

    rVal = Latch.ar(sum, DelayN.ar(trig1+trig2, (3*fftMax/2)-(3*fftSize/2)+BlockSize.ir/SampleRate.ir, fftMax-fftSize+BlockSize.ir/SampleRate.ir)).clip(-1,1);

    rVal = DelayN.ar(rVal, trigPeriod/2, trigPeriod/2);

    localIn = LocalIn.ar(1).clip(-1,1);
    localIn = DelayN.ar(localIn, trigPeriod/2-(BlockSize.ir/SampleRate.ir), trigPeriod/2-(BlockSize.ir/SampleRate.ir));

    rVal1 = (Latch.ar(rVal, trig1)>=0).linlin(0,1,-1,1)*
    Latch.ar(XFade2.ar(K2A.ar(1), localIn, EnvGen.kr(Env([-1,-1, 1], [trigPeriod, 0]), 1)), trig1);

    rVal2 = (Latch.ar(rVal, trig2)>=0).linlin(0,1,-1,1)*
    Latch.ar(XFade2.ar(K2A.ar(1), DelayN.ar(rVal1.clip(-1,1), trigPeriod/2, trigPeriod/2), EnvGen.kr(Env([-1,-1, 1], [trigPeriod, 0]), 1)), trig2);

    LocalOut.ar(rVal2);

    window0 = NessWindow.ar(trig1, rVal.abs, fftSize)*rVal1;
    window1 = NessWindow.ar(trig2, rVal.abs, fftSize)*rVal2;

    sig = DelayN.ar(sig, fftMax/SampleRate.ir, fftMax/SampleRate.ir);

    outSig = [sig[0]*window0, sig[1]*window1];

    hiPass = Clip.ir(hiPass*SampleRate.ir/2.0, 20.0, SampleRate.ir/2.0);
    lowPass = Clip.ir(lowPass*SampleRate.ir/2.0, 20.0, SampleRate.ir/2.0);
    outSig = HPF.ar(HPF.ar(outSig, hiPass), hiPass);
    outSig = LPF.ar(LPF.ar(outSig, lowPass), lowPass);

    Mix.new(outSig)

    };

    K.add(
        basename: \timestretch2,
        synthfunc: {|dur, buffer, fftVal=8192, fftMax=65536, hiPass, lowPass, stretch=10, startPos=0|
            // var thissig = filterVals.collect{|filterPair, splitNum|
            //     var fftVal = fftVals[splitNum];
            //     var hipass = filterPair[0];
            //     var lopass = filterPair[1];
            //
            //     SynthDef.wrap(timeStretchBand, prependArgs: [buffer, fftVal, fftMax, hipass, lopass, stretch, startPos]);
            // };

            var thissig = SynthDef.wrap(timeStretchBand, prependArgs: [buffer, fftVal, fftMax, hiPass, lowPass, stretch, startPos]);
            // thissig.poll.sum
            thissig

        }, numChannelsIn:1)

    }
)
(
var numSplits = 4; // Default is 9 but that's a bit too heavy for realtime
var durMult = 100;
var amp = 1;
var outChan = 0;

// ----------

var fftMax = 65536;
var sampleRate = s.sampleRate;
var filterVals = TimeStretch2.getFilterVals(sampleRate, numSplits);
var fftVals = TimeStretch2.getFFTVals(filterVals, fftMax);

~synths = filterVals.collect{|fv, i|
    Synth(K.get(\timestretch2, \adsr, \none),
        [
            \out, outChan,
            \dur, 8,
            \buffer, b.bufnum,
            \fftSize, fftVals[i].postln,
            \fftMax, fftMax,
            \stretch, durMult,
            \hiPass, fv[0].postln,
            \lowPass, fv[1].postln,
            \amp, amp,
            \autopan, 1,
            \pan, rrand(-1.0,1.0),
            \panFreq, rrand(0.1,0.01)
        ]
    )
};
)
