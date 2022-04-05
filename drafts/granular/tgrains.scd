/*
b = Buffer.read(s, M.sndPath.fullPath +/+ "harmshort.wav");
b.numChannels
M();

Pdef(\tg).clear;
(
Pdef(\tg, 
	Pbind(
		\instrument, M.get(\tgrains3x2, \adsr, \dfm1), \buffer, b
	)
).play
)

*/
(
	[1, 2].do{|numChans|

	M.add("tgrains3x%".format(numChans), {|density=10, grainsize=0.1, grainpos=0, grainrate=0.5, buffer| 
		var trigger = Dust2.kr(density);
		var shape = KGrainShapes().getWrap();
		var graindur = K_NC.kr("graindur", 0.1);

		TGrains3.ar(numChans, 
			trigger: trigger, 
			bufnum: buffer, 
			rate: grainrate, 
			centerPos: grainpos, 
			dur: graindur, 
			pan: 0, 
			amp: 0.9, 
			att: graindur / 2, 
			dec: graindur / 2, 
			window: shape, 
			interp: 4
		)
	}, numChannelsIn: numChans);
	}
)
