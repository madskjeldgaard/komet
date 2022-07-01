(
var panners = ();

panners.mono2mono = {|prefix, suffix|
	{|sig|sig}
};

panners.mono2stereo = {|prefix, suffix|
	{|sig, pan=0, panFreq=1, autopan=0, panShape=1|
		var panner = KAutoPan.ar(pan:pan, panFreq:panFreq, autopan:autopan, panShape:panShape);
		Pan2.ar(sig, panner)
	}
};

panners.stereo2mono = {|prefix, suffix|
	{|sig|sig.sum}
};

panners.stereo2stereo = {|prefix, suffix|
	{|sig, pan=0, panFreq=1, autopan=0, panShape=1|
		var panner = KAutoPan.ar(pan:pan, panFreq:panFreq, autopan:autopan, panShape:panShape);
		Balance2.ar(sig[0], sig[1], panner)
	}
};

// @TODO numChannelsOut ??
panners.mono2azimuth = {|prefix, suffix, numChannelsOut|
	{|sig, pan=0, width=2, orientation=0.5, panFreq=1, autopan=0, panShape=1|
		var panner = KAutoPan.ar(pan:pan, panFreq:panFreq, autopan:autopan, panShape:panShape);
		PanAz.ar(
			numChannelsOut,
			sig,
			panner,
			width: width,
			orientation: orientation
		)
	}
};

// @TODO numChannelsOut ??
// For any input sound with more than 1 channels
panners.multi2azimuth = {|prefix, suffix, numChannelsOut|
	{|sig,  pan=0, spread=1, width=2.0, orientation=0.5, levelComp=true, panFreq=1, autopan=0, panShape=1|
		var panner = KAutoPan.ar(pan:pan, panFreq:panFreq, autopan:autopan, panShape:panShape);

		SplayAz.ar(
			numChannelsOut,
			sig,
			spread: spread,
			level: 1,
			width: width,
			center: panner,
			orientation: orientation,
			levelComp: levelComp
		)
	}
};

// High order ambisonics encoders
(1..7).do{|order|
	var key = "mono2hoaO%".format(order).asSymbol;
	panners[key] = {|prefix, suffix|
		{|sig|

			// @TODO auto panning untested
			var anglePanner = KAutoPan.ar(
				pan:K_NC.kr("angle", 0),
				panFreq:K_NC.kr("panFreq", 1, prefix:"angle"),
				autopan:K_NC.kr("autopan", 0.0, prefix:"angle"),
				panShape:K_NC.kr("panshape", 1.0, prefix:"angle"),
			);

			var elevationPanner = KAutoPan.ar(
				pan:K_NC.kr("elevation", 0),
				panFreq:K_NC.kr("panFreq", 1, prefix:"elevation"),
				autopan:K_NC.kr("autopan", 0.0, prefix:"elevation"),
				panShape:K_NC.kr("panshape", 1.0, prefix:"elevation"),
			);

			HoaEncodeDirection.ar(
				in: sig,
				theta: anglePanner * pi,
				phi: elevationPanner * pi,
				radius: K_NC.kr("radius", AtkHoa.refRadius),
				order: order
			);
		}
	}
};

(1..7).do{|order|

	panners.put("stereo2hoaO%".format(order).asSymbol, {|prefix, suffix|
		{|sig|

			// @TODO auto panning untested
			var anglePanner = KAutoPan.ar(
				pan:K_NC.kr("angle", 0),
				panFreq:K_NC.kr("panFreq", 1, prefix:"angle"),
				autopan:K_NC.kr("autopan", 0.0, prefix:"angle"),
				panShape:K_NC.kr("panshape", 1.0, prefix:"angle"),
			);

			var elevationPanner = KAutoPan.ar(
				pan:K_NC.kr("elevation", 0),
				panFreq:K_NC.kr("panFreq", 1, prefix:"elevation"),
				autopan:K_NC.kr("autopan", 0.0, prefix:"elevation"),
				panShape:K_NC.kr("panshape", 1.0, prefix:"elevation"),
			);

			var numChansIn = 2;

			Array.fill(numChansIn, {|chan|
				HoaEncodeDirection.ar(
					in: sig[chan],
					theta: (anglePanner * pi * (1+(chan*K_NC.kr("stereospread", 0.25)))).wrap2(pi),
					phi: elevationPanner * pi,
					radius: K_NC.kr("radius", AtkHoa.refRadius),
					order: order
				);
			}
		).sum
		}
	});

};

panners;
)
