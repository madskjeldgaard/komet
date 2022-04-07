(
K.add(
    basename: \ness,
    synthfunc: { |dur, bufnum, stretch = 100, startPos = 0, fftSize = 8192, fftMax = 65536, hiPass = 0, lowPass=0, amp = 1, gate = 1|
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
				sig = DelayC.ar(sig, (3*fftMax/2)-(3*fftSize/2)+BlockSize.ir/SampleRate.ir, fftMax-fftSize+BlockSize.ir/SampleRate.ir);

				sig[1] = DelayC.ar(sig[1], trigPeriod/2, trigPeriod/2);

				sum = RunningSuK.ar((sig[0]*sig[1]), fftSize/2)/RunningSuK.ar((sig[0]*sig[0]), fftSize/2);

				rVal = Latch.ar(sum, DelayC.ar(trig1+trig2, (3*fftMax/2)-(3*fftSize/2)+BlockSize.ir/SampleRate.ir, fftMax-fftSize+BlockSize.ir/SampleRate.ir)).clip(-1,1);

				rVal = DelayC.ar(rVal, trigPeriod/2, trigPeriod/2);

				localIn = LocalIn.ar(1).clip(-1,1);
				localIn = DelayC.ar(localIn, trigPeriod/2-(BlockSize.ir/SampleRate.ir), trigPeriod/2-(BlockSize.ir/SampleRate.ir));

				rVal1 = (Latch.ar(rVal, trig1)>=0).linlin(0,1,-1,1)*
				Latch.ar(XFade2.ar(K2A.ar(1), localIn, EnvGen.kr(Env([-1,-1, 1], [trigPeriod, 0]), 1)), trig1);

				rVal2 = (Latch.ar(rVal, trig2)>=0).linlin(0,1,-1,1)*
				Latch.ar(XFade2.ar(K2A.ar(1), DelayC.ar(rVal1.clip(-1,1), trigPeriod/2, trigPeriod/2), EnvGen.kr(Env([-1,-1, 1], [trigPeriod, 0]), 1)), trig2);

				LocalOut.ar(rVal2);

				window0 = NessWindow.ar(trig1, rVal.abs, fftSize)*rVal1;
				window1 = NessWindow.ar(trig2, rVal.abs, fftSize)*rVal2;

				sig = DelayC.ar(sig, fftMax/SampleRate.ir, fftMax/SampleRate.ir);

				outSig = [sig[0]*window0, sig[1]*window1];

				// bigEnv = EnvGen.kr(Env.asr(0,1,0), gate, doneAction:2);

				hiPass = hiPass*SampleRate.ir/2;
				lowPass = lowPass*SampleRate.ir/2;

				outSig = HPF.ar(HPF.ar(outSig, (hiPass).clip(20, SampleRate.ir/2)), (hiPass).clip(20, SampleRate.ir/2));
				outSig = LPF.ar(LPF.ar(outSig, (lowPass).clip(20, SampleRate.ir/2)), (lowPass).clip(20, SampleRate.ir/2));

                Mix.new(outSig);

				// Out.ar(out, Mix.new(outSig)*bigEnv*amp);

				//Out.ar(out, [sig[0], sig[1], rVal, window0, window1])
    })
)
