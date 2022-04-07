/*

// Example
b = Buffer.read(s, K.sndPath.fullPath +/+ "harmshort-mono.wav");
M();
z = Synth(K.get('paulstretch1'), [\buffer, b, \stretchscale, 2, \amp, 1, \pitchMix, 0.5]);
x = Synth(K.get('paulstretch'), [\buffer, b, \stretchscale, 2.1, \amp, 1, \pan, 1, \pitchMix, 0.5, \pitchHarm, 2.01]);
K.genPat('paulstretch');
(
// Pdef('210818_155914').clear;
Pdef('210818_155914',
	Pbind(
		\instrument, K.get('paulstretch', 'adsr'),
		\dur, Pwhite(4.1,8).trace,
		\buffer, b,
		\timestretch, Pexprand(80.0,1000.0),
		\stretchscale, 2.0,
		\trigratescale, 1.02,
		\legato, 2,
		\vcaattack, 0.5,
		\pan, Pwhite(-1.0,1.0),
		\grainshape, Pwhite(),
		\autopan, 1, \panFreq, Pwhite(0.001,0.1),
		\window, 0.5,
		\pitchMix, 0.5,
		\pitchHarm, Pwhite(2,8),
		\bpFreq, Pexprand(100.0, 1440),
		\bpWidth, Pbrown(4,12,1),
		\amp, 0.99,
	)
).play
)

m = OFX_OutputFX.new(server: s,  numChannels: 2,  slotNames: [\ofx_jpverb]);
K.add(\ofx_jpverb, 0.5);
K.gui;

*/
(

	// from https://github.com/dwtong/glaciers/blob/main/lib/Engine_Glacial.sc
	// NOTE: Input buffer must be mono!

	// @TODO make compatible with stereo inputs (we need envelope buffers in different amounts of channels)

	// var paulstretch_grain_buf = Buffer.alloc(server: s,  numFrames: s.sampleRate,  numChannels: 1);
	// 	paulstretch_grain_buf.loadCollection(Signal.newClear(Server.local.sampleRate).waveFill({|x| (1 - x.pow(2)).pow(1.25)}, -1.0, 1.0));
(1..1).do{|numChannels|
	K.add("paulstretch%".format(numChannels), {
		arg dur, buffer, timestretch=100, stretchscale=1, window=0.25,
		pitchMix=0, pitchHarm=2.0,
		bpFreq=440, bpWidth=10, trigratescale=1;
		var trigPeriod, sig, chain, trig, pos, fftSize, fftCompensation;

		var envbuf = KGrainShapes().getWrap();
		// var envbuf = paulstretch_grain_buf;

		// Calculating fft buffer size according to suggested window size
		// Reduce by half to optimise for Norns
		// fftSize = (2 ** floor(log2(window * SampleRate.ir))) / 2;
		fftSize = (2 ** floor(log2(window * SampleRate.ir)));

		// scale stretch based on buffer size
		timestretch = timestretch * stretchscale;

		// Windows (using grains)
		trigPeriod = trigratescale * (fftSize/SampleRate.ir );
		trig = Impulse.ar(1/trigPeriod);

		// grain position
		// second grain position is offset
		pos = Demand.ar(trig, 0, demandUGens: Dseries(0, trigPeriod/timestretch));
		pos = [pos, pos + (trigPeriod/(2 * timestretch))];
		sig = GrainBuf.ar(numChannels, trig, trigPeriod, buffer, trigratescale, pos, envbufnum: envbuf);

		// FFT Processing
		sig = sig.collect({ |item, i|
			// convert signal to fft (frequency domain)
            var thisbuf = LocalBuf(fftSize, numChannels: numChannels);
            var wintype = 0;
			chain = FFT(thisbuf, item, hop: 1.0, wintype: wintype);

			// randomise phase as per paulstretch algo
			chain = PV_Diffuser(chain, trig);

			// convert back to ifft (time domain)
			IFFT(chain, wintype: wintype);
		});

		// Reapply the grain envelope because the FFT phase randomization removes it
		sig = sig * PlayBuf.ar(numChannels, envbuf, 1/(trigPeriod), loop:1, doneAction: 0);

		// Delay second grain by half a grain length for superposition
		sig[1] = DelayC.ar(sig[1], trigPeriod/2, trigPeriod/2);

		// Compensate for delay introduced by FFT
		fftCompensation = (fftSize - BlockSize.ir)/SampleRate.ir;
		sig = DelayC.ar(sig, fftCompensation, fftCompensation);

		// Filtering
		sig = BBandPass.ar(sig, bpFreq, bpWidth);

		// Panning
		sig = Mix.new(sig);

		// Pitch shifting
		sig = XFade2.ar(sig, PitchShift.ar(sig, trigPeriod, pitchHarm, 0, 0.1), pitchMix * 2 - 1);

		sig

	}, numChannelsIn: numChannels)
}
)
