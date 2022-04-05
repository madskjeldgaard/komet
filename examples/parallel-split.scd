K_FX.new(2);
K_FX.addParallel2(\comb, \vocoder8bands, \channelized);

b = Buffer.read(s, "~/sounds/SamuraiCop.wav".asAbsolutePath);
b.play(loop:true);

z = Synth.tail(1, K_FX.get(\par2_freqshift_pitchshift1, \channelized));
z.set(\pitchDispersion, 0.1, \timeDispersion,0.1, \drywet, 0.5)
z.set(\pitchRatio, 1.2, \shiftfreq, 100.2, \drywet, 0.5)

v = Synth.tail(1, K_FX.get(\jpverb, \stereo), [\drywet, 0.25, \modFreq, 0.1]);
