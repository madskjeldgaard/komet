// TODO: This currently sucks
/*
(
	[1,2].do{|numChannels|
	K.add(\Kgrain, { |buffer|
		var numGrains = 4;
		var grainRate = K_NC.ar("grainRate", 1);
		var playRate = K_NC.ar("playRate", 0.25);
		var wobble = K_NC.ar("wobble", 0.5);
		var shape = K.embedWithGrainShapes(); 

		var grains = Array.fill(numGrains, {|grainNum|
			var windowPhasor = Phasor.ar(0, 
				BufRateScale.kr(shape) * grainRate * LFNoise2.kr(wobble*10).range(1.0,1.0+wobble), 
				0, 
				BufFrames.kr(shape)
			);

			var soundPhasor = Phasor.ar(0, 
				BufRateScale.kr(buffer) * playRate * (grainNum+1), 
				0, 
				BufFrames.kr(buffer),
				grainNum/numGrains
			).poll(label: grainNum);

			var window = DelayC.ar(BufRd.ar(1, 
				shape, 
				// windowPhasor * BufFrames.kr(shape) , 
				windowPhasor,
				loop:1,
				interpolation:4
			), delaytime: grainNum/numGrains * LFNoise2.kr(1).range(0.25,0.01));

			var sound = BufRd.ar(numChannels,
				buffer,
				soundPhasor,
				loop: 1,
				interpolation: 4
			);

			window * sound

		});

		Splay.ar(grains, spread: 0.5);

	}, numChannelsIn: 2);
	}
)
*/
(
	// MUST HAVE MONO INPUT
	(1..2).do{|numChannels|
	K.add("tgrain%".format(numChannels), {|buffer|
		var clock = Dust2.ar(K_NC.kr("graindensity", 10.5)).poll(label:"clockkkk");
		var shape = K.embedWithGrainShapes(); 

		TGrains3.ar(numChannels.poll(label: "numc"), 
			clock.poll(label: "clock"),
			buffer.poll(label: \buff), 
			K_NC.kr("grainrate", 1.5),
			dur: K_NC.kr("graindur", 0.01),
			centerPos: LFNoise2.kr(0.5).range(0, BufDur.kr(buffer)) + TRand.kr(0, 0.02, clock), 
			// rate: K_NC.kr("rate", 0.5) * BufDur.kr(buffer),
			// amp: 0.5,
			att: K_NC.kr("grainAttack", 0.001),
			dec: K_NC.kr("grainDecay", 0.001),
			window: shape,
			// interp: 4
		).poll

	}, numChannelsIn: numChannels);
	}
)

