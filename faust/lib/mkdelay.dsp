import("stdfaust.lib");
import("lib/mkfilters.dsp");

mkd = environment {
	   // "Natural comb" - aka a comb filter with a onepole LPF in the feedback path
	   comblpf(order, maxdelay, delay, fb, lpfcutoff) =
	   (+ : de.fdelayltv(order, maxdelay, delay)) ~ (* (fb) : mkf.onepolelpf(lpfcutoff)) : fi.dcblocker;

	   // X number of parallel "natural combs". Multi channel out
	   parallel_comb_lpf(numDelays, order, maxdelay, delay, delayOffset, fb, lpf) =
		   par(delayNum, numDelays, delaySig(delayNum))
			   with{
				   delaySig(i) = comblpf(order, maxdelay * (i+1), delay * (i+1+delayOffset), fb, lpf) : *(1.0/numDelays);
			   };

		// Same as above but with each comb panned in stereo
		parallel_comb_lpf_splayed(numDelays, order, maxdelay, delay, delayOffset, fb, lpf, spread, rotate) =
			parallel_comb_lpf(numDelays, order, maxdelay, delay, delayOffset, fb, lpf)
			<: par(i,numDelays, pan(i, spread, rotate))
			:> _, _
			   with{
				   pan(i, spread, rotate, input) = sp.panner(panval(i, spread, rotate));
				   panval(i, spread, rotate) = (i / numDelays) : *(spread) : +(rotate);
			   };

};
