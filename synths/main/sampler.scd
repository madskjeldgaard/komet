(

[1,2].do{|numChannels|

    var desc = "A % channel buffer player with pitch envelope",
    func = {|dur, buffer, rate=1, rateOffset=0, loop=1, direction=0, startPosition=0|
        var dir = Select.kr(direction, [1,(-1)]);
        var lagTime = \lagTime.kr(1);
        var pitchEnv = KEnvelopes().getWrap(\adsr, "pitch", "", dur, 0);

        // When playing backwards
        var startOffset = Select.kr(direction, [0,1]);
        var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0).klag(lagTime);

        var wowParam = K_NC.kr("wow", 0).klag(lagTime);
        var wow = LFDNoise3.kr(
            wowParam.linexp(0.0,1.0,0.01,10.0)
        ).range(1.0 + wowParam, 1.0 - wowParam);

        rate = (dir * rate + rateOffset.klag(lagTime) * wow) * BufRateScale.kr(buffer);

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
        )
    },
    type = \synth,
    category = \buffer,
    basename = "sampler%".format(numChannels).asSymbol,
    numChans = numChannels,
    specs = (
        wow: [0.0,1.0],
        rate:[-100.0,100.0],
        loop: [0,1],
        direction: [0,1],
        startPosition: [0.0,1.0],
        pitchEnvAmount: [0.0, 1.0],

        pitchattack: \attack,
        pitchrelease: \release,
        pitchdecay: \decay,
        pitchenvcurve: \envcurve,
        pitchsustainLevel: \sustainLevel
    );

    KometSynthFuncDef(
        basename,
        func,
        type,
        category,
        numChans,
        desc,
        specs,
    ).add();

};
)
