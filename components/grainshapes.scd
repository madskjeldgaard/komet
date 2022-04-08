(
	var grainenvelopes = (
		sinc: Env( Array.series(32, -16, 1).collect{|x| if(x == 0, {1}, { x.sin/x })}, {1/31}!31),
		quasi: Env([0, 1, 1, 0], [0.25, 0.5, 0.25], \sin), // quasi gaussian
		three: Env([0, 1, 1, 0], [0.25, 0.5, 0.25], \lin), // Three line segment
		tri: Env([0, 1, 0], [0.5, 0.5], \lin),
		welch: Env([0, 1, 1, 0], [0.25, 0.5, 0.25], \welch), // Welch curve
		expodec: Env([1, 0.0001], [1.0], \exp), // Exponential decay
		click: Env([1,1], [1]),
		hamm: {
		// Taken from https://github.com/khoin/ExtraWindows
		var envDuration = 1.0; // 500ms
		var envResolution = 20;
		var alpha = 3;

		var levels = Array.fill( envResolution , { arg x;
		var coeff = 0.53836;
		x = x/envResolution;
		(coeff - ((1-coeff)*(2*x).cosPi));
		});

		var times = Array.fill( envResolution - 1, envDuration / ( envResolution - 1 ) ).normalizeSum;

		Env( levels, times, \lin)

		}.value,

		hann: {
		// Taken from https://github.com/khoin/ExtraWindows
		var envDuration = 1.0; // 500ms
		var envResolution = 20;
		var alpha = 3;

		var levels = Array.fill( envResolution , { arg x;
		x = x/envResolution;
		x.sinPi.squared;
		});
		var times = Array.fill( envResolution - 1, envDuration / ( envResolution - 1 ) ).normalizeSum;

		Env( levels, times, \lin)

		}.value,

		gauss: {
		// Taken from https://github.com/khoin/ExtraWindows
		var envDuration = 1.0; // 500ms
		var envResolution = 20;
		var alpha = 3;

		var levels = Array.fill( envResolution , {
		arg i;
		((-0.5) * (((i / envResolution )-0.5) * alpha * 2).squared).exp; }
		);

		var times = Array.fill( envResolution - 1, envDuration / ( envResolution - 1 ) ).normalizeSum;

		Env( levels, times, \lin)
		}.value,
		rexpodec: Env([0.0001, 1], [1.0], \exp), // Reverse exponential decay
		perc: Env([ 0, 1.0, 0 ], [ 0.01, 0.99 ], -4.0),
		sine: Env.sine
	);

// 	grainenvelopes.keysValuesDo{|shapename, envelope|
// 		var buffer = Buffer.sendCollection(Server.local, envelope.discretize, 1);

// 		KometSynthFactory.addGrainShapeBuffer(shapename, buffer);
// 	};

grainenvelopes;
)
