(
[1,2].do{|numChannels| KometSynthFactory.add("sampler%".format(numChannels), {
	|dur, buffer, rate=1, loop=1, direction=0, startPosition=0|
	var dir = Select.kr(direction, [1,(-1)]);
    var lagTime = \lagTime.kr(1);
	var pitchEnv = KEnvelopes().getWrap(\adsr, "pitch", "", dur, 0);

	// When playing backwards
	var startOffset = Select.kr(direction, [0,1]);
	var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0).klag(lagTime);

	rate = dir * rate.klag(lagTime) * BufRateScale.kr(buffer);

	rate = pitchEnv.linlin(
		0.0,
		1.0,
		rate + (rate * pitchenvAmount),
		rate - (rate * pitchenvAmount)
	);

	PlayBuf.ar(numChannels,
		buffer,
		rate: rate,
		startPos: (startOffset-startPosition) * BufFrames.kr(buffer),
		loop: loop
	)}, numChannelsIn: numChannels)
};
)
