(
KometSynthFactory.add("oscbank", {|dur, freqOffset=0|
var lagTime = \lagTime.kr(1);
	OscBank.ar(
		freq:(K_NC.kr("freq", 100) + freqOffset).klag(lagTime),
		gain:K_NC.kr("gain", 1),
		saw8:K_NC.kr("saw8", 0.5),
		square8:K_NC.kr("square8", 0.5),
		saw4:K_NC.kr("saw4", 0.5),
		square4:K_NC.kr("square4", 0.5),
		saw2:K_NC.kr("saw2", 0.5),
		square2:K_NC.kr("square2", 0.5),
		saw1:K_NC.kr("saw1", 0.5)
	)
	}, numChannelsIn: 1);
)
