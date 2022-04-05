M(force:true);

(
K.add(\dub1, { 
	var freq = \freq.kr(100, spec:Spec.specs[\freq]);
	var subfreq = \subFreq.kr(100, spec:Spec.specs[\freq]);
	var freqs = [
		freq, subfreq
	];
	var oscs = BLOsc.ar(freq: freqs,  pulsewidth: 0.5,  waveform: [1,2]) * [1, K_NC.kr("subOscAmp", 0.5)];
	
	var modAmount = K_NC.kr("modDepthHz", 50, spec: Spec.specs[\freq]);
	var modulation = LFTri.ar(K_NC.kr("modfreq", 1, spec: Spec.specs[\freq]), iphase: Rand(0.0,1.0)).linlin(-1.0,1.0,0, modAmount);

	oscs = BPF.ar(
		oscs.sum, 
		freq: modulation + K_NC.kr("bpfcutoff", 2500, spec: Spec.specs[\freq]), 
		rq: \q.kr(1.1, spec: [0.00001,10.0,\exp])
	);

	oscs;
}, 
withFilter: true);
)
SynthDescLib.global.browse;
SynthDescLib.read;
(
// Chords
Pdef(\dub1, 
	Pbind( 
		\instrument, \dub1_perc_dfm12, 
		\octave, 4,
		\scale, Scale.minor, 
		\degree, Pwrand([0,2,3], [0.75,0.15,0.1], inf) + [0,2,4], 
		\gate, 1,
		\modDepthHz, 500,
		\modFreq, Pwhite(10.001,100.0), 
		\q, Pseg(Pseq([0.225,3.0],inf), Pwhite(10,20),\exp, inf),
		\bpfcutoff, Pwhite(100,500), 
		\vcaattack, 0.05,
		\vcarelease, Psinen(0.1) + 2.5,
		\vcaenvcurve, -8,
		\pan, Pwhite(-1.0,1.0),
		\dur, 1,
		// \dur, Pseg([0.15,4.0], 16, \exp, inf)
	)
).play;
)

(
SynthDef(\vstplugin, { arg bus;
	var numChannels = 2;
	ReplaceOut.ar(bus, VSTPlugin.ar(In.ar(bus, numChannels), numChannels));
}).add;
)

// Build cache
VSTPlugin.search;

~fx = VSTPluginController(Synth.after(1, \vstplugin, [\bus, 0])).open("ValhallaVintageVerb");
~fx.set(\Mix, 0.5);


SynthDescLib.global.browse
Synth(\dub1_perc_dfm12, [\freq, [100,150,200].choose, \bpfcutoff, exprand(50,1500), \bpfmodFreq, rrand(0.001,2.0), \q, rrand(0.001,4.0)])
