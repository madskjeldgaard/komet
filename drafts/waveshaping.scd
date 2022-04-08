// Waveshaping buffers to be used with Shaper.ar
// Some of these were pulled out of Aaron Lanterman's Buchla 700 project: https://github.com/lantertronics/b700ish/blob/main/b700ish.scd

(
	KometSynthFactory.poster("Loading waveshaper algos");

	// Coeffecients
	~waveShapeCoeffecients = IdentityDictionary.new;
	~waveShapeCoeffecients.put('truetriangle ', [1,0] / ((1..32).squared));
	~waveShapeCoeffecients.put('squarecompatible_triangle', [1,0,-1,0] / ((1..32).squared));
	~waveShapeCoeffecients.put('jimmysmithpositive', [1,1,1]);
	~waveShapeCoeffecients.put('jimmyshith', [1,1,-1]);
	~waveShapeCoeffecients.put('fulltonewheel', [1,1,-1,-1,0,1,0,-1,0,1,0,-1,0,0,0,1]);
	~waveShapeCoeffecients.put('truesquare', [1,0,-1,0] / (1..32));
	~waveShapeCoeffecients.put('trianglecompatible_square', [1,0] / (1..32));
	~waveShapeCoeffecients.put('altsaw', 0.25*[1,-1,-1,1] / (1..32));
	~waveShapeCoeffecients.put('altimpulsetrain', 0.1*[1,-1,-1,1]*Array.fill(32,1));
	~waveShapeCoeffecients.put('altsignflipping_impulse_train', 0.1*[1,0,-1,0]*Array.fill(32,1));

	// Convert coeffecients to waveshaping buffers
	~shaperBuffers = IdentityDictionary.new;

	~waveShapeCoeffecients.keysValuesDo{|name, coeffecients|
		var waveShapeSignal = Signal.chebyFill(4096, coeffecients, normalize: true, zeroOffset:false);
		var buf = Buffer.loadCollection(s, waveShapeSignal.asWavetableNoWrap);
		KWaveShapeLib.addWaveshapeBuffer(name, buf)
	};

	// A function for embedding in a synthdef using SynthDef.wrap
	
	// Pass through
	KWaveShapeLib.addWaveshapeWrapper(\n, { arg sig; sig });

	// One waveshaper
	KWaveShapeLib.addWaveshapeWrapper(\ws, {
		arg sig, 
		waveshapeGain=1,
		waveshapeAmount=0.01, 
		waveshape=0;
		var clean = sig;

		// This wrapping trick is necessary to embed all the buffers in the synth. 
		// This way you don't have to supply them as arguments 
		var shapeBuffers = SynthDef.wrap({ KometSynthFactory.shapeBuffers.asArray });
		var shape = Select.kr((waveshape % KometSynthFactory.shapeBuffers.size), shapeBuffers);
		sig = Shaper.ar(shape, waveshapeGain *sig );
		LeakDC.ar(XFade2.ar(clean, sig, waveshapeAmount.linlin(0.0,1.0,-1.0,1.0)));
	});

	// This one crossfades
	KWaveShapeLib.addWaveshapeWrapper(\wxs, {
		arg sig, 
		waveshapeAmount=0.01,
		waveshapeGain=1,
		waveshapeA=0,
		waveshapeB=4,
		waveshapeCrossfade=0;
		var clean = sig;

		var shapeBuffers = SynthDef.wrap({ KometSynthFactory.shapeBuffers.asArray });
		var shapeA = Select.kr((waveshapeA % KometSynthFactory.shapeBuffers.size), shapeBuffers);
		var shapeB = Select.kr((waveshapeB % KometSynthFactory.shapeBuffers.size), shapeBuffers);

		var sigA = Shaper.ar(shapeA, waveshapeGain * sig );
		var sigB = Shaper.ar(shapeB, waveshapeGain * sig );

		sig = XFade2.ar(sigA, sigB, waveshapeCrossfade);

		LeakDC.ar(XFade2.ar(clean, sig, waveshapeAmount.linlin(0.0,1.0,-1.0,1.0)));
	});
)
