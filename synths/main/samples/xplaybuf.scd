(
// Overlapping sampler
[1,2].do{|numChannels|
	K.add("xplaybuf%".format(numChannels), {
		|dur, buffer, rate=1, loop=1, loopDur=(-1), startPos=0, fadeTime=0.001, trigger=1, direction=0|
        var lagTime = \lagTime.kr(1);
		var dir = Select.kr(direction, [1,(-1)]);
		var wowParam = K_NC.kr("wow", 0).Klag(lagTime);
		var wow = LFNoise2.kr(
			wowParam.linexp(0.0,1.0,0.01,10.0)
		).range(1.0 + wowParam, 1.0 - wowParam);

		var pitchEnv = KEnvelopes().getWrap(\adsr, "pitch", "", dur, 0);
		var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0).Klag(lagTime);

		rate = dir * rate.Klag(lagTime) * BufRateScale.kr(buffer);

		rate = pitchEnv.linlin(
			0.0,
			1.0,
			rate + (rate * pitchenvAmount),
			rate - (rate * pitchenvAmount)
		);

		rate = rate * wow;

		XPlayBuf.ar(
			numChannels: numChannels,
			bufnum: buffer,
			rate: rate,
			trigger: trigger,
			startPos: startPos,
			loopDur: loopDur,
			loop: loop,
			fadeTime: fadeTime
		);

	}, numChannelsIn: numChannels)
}
)
