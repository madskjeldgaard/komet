(
var desc = "A remix of Mutable Instrument's Rings algorithm",
func = {|dur, freq=440, freqOffset=0, sustainTime=0.05, structure=0.5, brightness=1, damping=0.75, accent=0.9, harmonicstretch=0.5, position=0.15, loss=0.15|

    var lagTime = \lagTime.kr(0.001);
    var trig = Trig1.kr(in: 1,  dur: sustainTime);
	var modeNum = \modeNum.ir(2);
	var cosFreq = \cosFreq.ir(0.025);
    freq = freq + freqOffset;
    freq = freq.kWithPitchEnv(
        dur,
        K_NC.kr("pitchEnvAmount", 0),
        envType:\adsr
    );

    freq = freq.kWithWow(
        K_NC.kr("wow", 0.0),
        wowMinFreq:0.01,
        wowMaxFreq: 10.0
    );

    // TODO: This is silly
    freq = A2K.kr(freq);

    Rongs.ar(
		trigger:trig,
		sustain:trig,
		f0:freq,
		structure:structure.klag(lagTime),
		brightness:brightness.klag(lagTime),
		damping:damping.klag(lagTime),
		accent:accent.klag(lagTime),
		stretch:harmonicstretch.klag(lagTime),
		position:position.klag(lagTime),
		loss:loss.klag(lagTime),
		modeNum:modeNum,
		cosFreq:cosFreq
	)
},
    type = \synth,
    category = \physical,
    basename = \rongs,
    numChans = 1,
    specs = (
        freq: Spec.specs[\freq],
        //TODO
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

)
