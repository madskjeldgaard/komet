(
[1,2].do{|numChannels|
    var buffer_duration = 10;
    var desc = "A granular synth inspired by MI Beads with a Buffer Player as sound source",
    func = {|dur, buffer, rate=1, rateOffset=0, loop=1, direction=0, startPosition=0|
        var sig, reverse;
        var dir = Select.kr(direction, [1,(-1)]);
        var lagTime = \lagTime.kr(1);

        // When playing backwards
        var startOffset = Select.kr(direction, [0,1]);
        var pitchenvAmount = K_NC.kr("pitchEnvAmount", 0).klag(lagTime);
        var wowParam = K_NC.kr("wow", 0).klag(lagTime);

        rate = (dir * rate + rateOffset.klag(lagTime)) * BufRateScale.kr(buffer);
        rate = rate.kWithPitchEnv(dur, pitchenvAmount, envType: \adsr);
        rate = rate.kWithWow(wowParam, wowMinFreq: 0.01, wowMaxFreq:10.0);

        sig = PlayBuf.ar(numChannels,
            buffer,
            rate: rate,
            startPos: (startOffset-startPosition) * BufFrames.kr(buffer),
            loop: loop
        );
        // FIXME: This is wrong
        reverse = K_NC.kr(\reverse, 0);

        // TODO: Lag
        Musli.ar(
            in0:sig,
            freeze:K_NC.kr(\freeze, 0),
            seed:K_NC.kr(\seed, 0),
            density:K_NC.kr(\density, 1),
            feedback:K_NC.kr(\feedback, 0),
            inputgain:K_NC.kr(\inputgain, 0),
            outputgain:K_NC.kr(\outputgain, 0),
            pitch:K_NC.kr(\pitch, 0),
            reverse:reverse,
            shape:K_NC.kr(\shape, 0),
            size:K_NC.kr(\size, 0.5),
            time:K_NC.kr(\time, 0)
        );
    },
    type = \synth,
    category = \granular,
    basename = "musliplayer%".format(numChannels).asSymbol,
    numChans = numChannels, // TODO: Not used
    specs = (
        freeze: [0,1],
        seed: [0,1],
        density: [0.01,10.0, \exp],
        feedback: [0.0,1.0],
        inputgain: Spec.specs[\db],
        outputgain: Spec.specs[\db],
        pitch: [-24.0,24.0],
        reverse: [0,1],
        shape: [0.0,1.0],
        size: [0.0, buffer_duration,\exp],
        time: [0.0,1.0],
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

}
)
