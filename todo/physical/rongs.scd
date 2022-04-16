(

KometSynthFactory.add("rongs", {|dur, sustainTime=0.05, freq=440, structure=0.5, brightness=0.5, damping=0.75, accent=0.9, harmonicstretch=0.5, position=0.15, loss=0.15|
    var lagTime = \lagTime.kr(1);
	var trig = Trig1.kr(in: 1,  dur: sustainTime);
	var modeNum = \modeNum.ir(2);
	var cosFreq = \cosFreq.ir(0.025);

	Rongs.ar(
		trigger:trig,
		sustain:trig,
		f0:freq.klag(lagTime),
		structure:structure.klag(lagTime),
		brightness:brightness.klag(lagTime),
		damping:damping.klag(lagTime),
		accent:accent.klag(lagTime),
		stretch:harmonicstretch.klag(lagTime),
		position:position.klag(lagTime),
		loss:loss.klag(lagTime),
		modeNum:modeNum,
		cosFreq:cosFreq
	);

}, numChannelsIn: 1);
)
