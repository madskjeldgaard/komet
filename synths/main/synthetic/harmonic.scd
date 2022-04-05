(
K.add("harmonic", {|dur, freqOffset=0|
    var lagTime = \lagTime.kr(1);

	var amplitudes = Array.fill(16, {|i| KNC.kr("amp%".format(i+1), 1/16) });
	HarmonicOsc.ar(freq: (KNC.kr("freq", 100) + freqOffset).Klag(lagTime),  firstharmonic: KNC.kr("first", 3),  amplitudes: amplitudes)
}, numChannelsIn: 1);
)
