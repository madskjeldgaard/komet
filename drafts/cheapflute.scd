/*

M();
KometSynthFactory.genPat('cheapflute');

*/
(
KometSynthFactory.add("cheapflute", {|freq=440,  noiseLvl=0.1,gaussLvl=0.2|
	var numOvertones = 4;
	var freqs= [freq]++({|i| freq*(i+2)*LFGauss.ar(0.001, gaussLvl)}!(numOvertones-1));
	var phases= {2pi.rand}!numOvertones;
	var amplitudes= {|i| 1-(i/(numOvertones+3))**6}!numOvertones;
	var flute= Mix(SinOsc.ar(freqs, phases, amplitudes));
	var noise= PinkNoise.ar(noiseLvl);
	flute = flute*AmpComp.kr(freq)+noise;

	LeakDC.ar(flute);
}, numChannelsIn: 1);
)
