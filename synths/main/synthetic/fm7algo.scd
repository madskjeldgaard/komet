// (
// 32.do{|algo|
// 	var basename = "fm7algo%".format(algo);

// 	K.add(basename, { |dur, freq=100, ratio=1, detuneAmount=0.1, feedback=0|
// 		var ctrls = Array.fill(6, {|i|
// 			var phase = rrand(0.0,2pi);
// 			[freq * (i+1 * ratio) * LFNoise2.kr(rrand(0.5,2.0)).range(1.0, 1.0-(detuneAmount/10.0)), phase, 1]
// 		});

// 		var sig = FM7.arAlgo(algo, ctrls, feedback);

// 		Splay.ar(sig, spread: 0.25);
// 	}, numChannelsIn: 2);
// }
// )
