(
K.add("oscbank", {|dur, freqOffset=0|
var lagTime = \lagTime.kr(1);
	OscBank.ar(
		freq:(KNC.kr("freq", 100) + freqOffset).Klag(lagTime),
		gain:KNC.kr("gain", 1),
		saw8:KNC.kr("saw8", 0.5),
		square8:KNC.kr("square8", 0.5),
		saw4:KNC.kr("saw4", 0.5),
		square4:KNC.kr("square4", 0.5),
		saw2:KNC.kr("saw2", 0.5),
		square2:KNC.kr("square2", 0.5),
		saw1:KNC.kr("saw1", 0.5)
	)
	}, numChannelsIn: 1);
)
