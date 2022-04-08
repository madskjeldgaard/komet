KWaveShapeLib {
    classvar <waveshapeWrappers, <shapeBuffers, <initialized; 

	*new{|waveshaperName, sig|
        this.init();
		^this.embedWithWaveshaper(waveshaperName, sig)
	}

    *init{
      shapeBuffers = shapeBuffers ?? {IdentityDictionary[]};
      waveshapeWrappers = waveshapeWrappers ?? {IdentityDictionary[]};
      initialized = true;
    }

	*addWaveshapeBuffer{|name, buffer|
      if(initialized != true, { this.init() });

		KometSynthFactory.poster("Adding waveshape buffer %".format(name));
		shapeBuffers.put(name, buffer);
	}

	*embedWithWaveshaper{|waveshaperName, sig|
      if(initialized != true, { this.init() });

		^SynthDef.wrap(
			KometSynthFactory.getWaveshapeWrapper(waveshaperName),  
			prependArgs: [sig]
		) 
	}

	// Waveshape wraper functions used with SynthDef.wrap
	*getWaveshapeWrapper{|name|

		if(
			waveshapeWrappers.keys.asArray.indexOfEqual(name).isNil,
			{
				KometSynthFactory.poster("Waveshape wrapper % not found", error: true);
				^nil
			}, 
			{
				^waveshapeWrappers[name]
			}
		)
	}

	*addWaveshapeWrapper{|name, func|
		KometSynthFactory.poster("Adding waveshape wrapper function %".format(name));
		waveshapeWrappers.put(name, func);
	}

	*shapeWrapperKinds{
		^waveshapeWrappers.keys
	}

}
