(

K.add("rongs", {|dur, sustainTime=0.05, freq=440, structure=0.5, brightness=0.5, damping=0.75, accent=0.9, harmonicstretch=0.5, position=0.15, loss=0.15|
    var lagTime = \lagTime.kr(1);
	var trig = Trig1.kr(in: 1,  dur: sustainTime);
	var modeNum = \modeNum.ir(2);
	var cosFreq = \cosFreq.ir(0.025);

	Rongs.ar(
		trigger:trig,
		sustain:trig,
		f0:freq.Klag(lagTime),
		structure:structure.Klag(lagTime),
		brightness:brightness.Klag(lagTime),
		damping:damping.Klag(lagTime),
		accent:accent.Klag(lagTime),
		stretch:harmonicstretch.Klag(lagTime),
		position:position.Klag(lagTime),
		loss:loss.Klag(lagTime),
		modeNum:modeNum,
		cosFreq:cosFreq
	);

}, numChannelsIn: 1);
)
