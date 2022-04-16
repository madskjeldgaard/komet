(
KometSynthFactory.add("harmonic", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);

	var amplitudes = Array.fill(16, {|i| K_NC.kr("amp%".format(i+1), 1/16) });
	HarmonicOsc.ar(freq: (K_NC.kr("freq", 100) + freqOffset).klag(lagTime),  firstharmonic: K_NC.kr("first", 3),  amplitudes: amplitudes)
}, numChannelsIn: 1);
)
