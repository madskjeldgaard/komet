b = Buffer.read(s, "~/testsound/whistle.wav".asAbsolutePath)

(
SynthDef(\looperOverlapping, {
	arg out=0, buffer=0, rate=1.0, trig=1, startPos=0.0, loopTime=1.0, overlapFactor=0.0;
	var bufferphasor, fade, phasorend, phasorstart, phasorrate, sig, times;

	phasorstart = startPos * SampleRate.ir();

	phasorend = phasorstart + (loopTime * 2 * SampleRate.ir());

	phasorrate = rate * BufRateScale.kr(buffer) * BufDur.kr(buffer).reciprocal / (phasorend-phasorstart/BufFrames.kr(buffer));
	bufferphasor = LFSaw.ar(phasorrate, iphase: [0, 1]);

	times = [0.01,0.98,0.01] * (1+overlapFactor);
	fade = IEnvGen.ar(
		Env([0,1,1,0], times),
		bufferphasor.linlin(-1.0,1.0,0.0,1.0) * times.sum
	);

	sig = fade * BufRd.ar(
		numChannels: 2,
		bufnum: buffer,
		phase: bufferphasor.linlin(-1.0,1.0, phasorstart, phasorend),
		loop: 0,
		interpolation: 4
	);

	// Sum the two overlapping players
	sig = sig.sum;

	Out.ar(bus:out, channelsArray:sig)
}).add;
)

Synth(\looperOverlapping, [\buffer, b, \rate, 0.5, \overlapFactor, 0.0])
