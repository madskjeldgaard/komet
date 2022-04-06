// Benjolin inspired instrument originally by Alejandro Olarte. Thanks Alejandro!!!

// z=Synth(K.get(\benjolis))
// z.set(\freq1, 1900.1, \freq2, 0.01, \rungler2,0.9, \scale, 1.0, \q, 0.95, \runglerFilt, 10)
// s.record;
(
K.add(\benjolis, { |dur, freq= 40, modFreq=20, scale=1, rungler1=0.16, rungler2=0.0, runglerFilt=9, loop=0, filtFreq=40, q=0.82, gain=1, internalFilterType=0, outSignal=6|
    var osc1, osc2, tri1, tri2, sh0, sh1, sh2, sh3, sh4, sh5, sh6, sh7, sh8=1, rungler, pwm, filt, output;
    var sr;
    var osc2freq, buf, bufR;

    bufR = LocalIn.ar(2,0);
    rungler = bufR.at(0);
    buf = bufR.at(1);

    sr = SampleDur.ir;
    //sr = ControlDur.ir;
    tri1 = LFTri.ar((rungler*rungler1)+freq);
    tri2 = LFTri.ar((rungler*rungler2)+modFreq);
    osc1 = PulseDPW.ar((rungler*rungler1)+freq);
    osc2 = PulseDPW.ar((rungler*rungler2)+modFreq);

    //pwm = tri1 > tri2;
    pwm = BinaryOpUGen('>', (tri1 + tri2),(0));

    osc1 = ((buf*loop)+(osc1* (loop* -1 +1)));
    sh0 = BinaryOpUGen('>', osc1, 0.5);
    sh0 = BinaryOpUGen('==', (sh8 > sh0), (sh8 < sh0));
    sh0 = (sh0 * -1) + 1;

    sh1 = DelayN.ar(Latch.ar(sh0,osc2),0.01,sr);
    sh2 = DelayN.ar(Latch.ar(sh1,osc2),0.01,sr*2);
    sh3 = DelayN.ar(Latch.ar(sh2,osc2),0.01,sr*3);
    sh4 = DelayN.ar(Latch.ar(sh3,osc2),0.01,sr*4);
    sh5 = DelayN.ar(Latch.ar(sh4,osc2),0.01,sr*5);
    sh6 = DelayN.ar(Latch.ar(sh5,osc2),0.01,sr*6);
    sh7 = DelayN.ar(Latch.ar(sh6,osc2),0.01,sr*7);
    sh8 = DelayN.ar(Latch.ar(sh7,osc2),0.01,sr*8);

    //rungler = ((sh6/8)+(sh7/4)+(sh8/2)); //original circuit
    //rungler = ((sh5/16)+(sh6/8)+(sh7/4)+(sh8/2));

    rungler = ((sh1/2.pow(8))+(sh2/2.pow(7))+(sh3/2.pow(6))+(sh4/2.pow(5))+(sh5/2.pow(4))+(sh6/2.pow(3))+(sh7/2.pow(2))+(sh8/2.pow(1)));

    buf = rungler;
    rungler = (rungler * scale.linlin(0,1,0,127));
    rungler = rungler.midicps;

    LocalOut.ar([rungler,buf]);

    filt = Select.ar(internalFilterType, [
        RLPF.ar(pwm,(rungler*runglerFilt)+filtFreq,q* -1 +1,gain),
        //BMoog.ar(pwm,(rungler*runglerFilt)+filtFreq,q,0,gain),
        RHPF.ar(pwm,(rungler*runglerFilt)+filtFreq,q* -1 +1,gain),
        SVF.ar(pwm,(rungler*runglerFilt)+filtFreq,q,1,0,0,0,0,gain),
        DFM1.ar(pwm,(rungler*runglerFilt)+filtFreq,q,gain,1)
    ]);

    output = Select.ar(outSignal, [
        tri1, osc1, tri2, osc2, pwm, sh0, filt
    ]);

    output = LeakDC.ar(output, 0.99).tanh;

    SafetyLimiter.ar(output)

})
)
