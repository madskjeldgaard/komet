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

		M.poster("Adding waveshape buffer %".format(name));
		shapeBuffers.put(name, buffer);
	}

	*embedWithWaveshaper{|waveshaperName, sig|
      if(initialized != true, { this.init() });

		^SynthDef.wrap(
			M.getWaveshapeWrapper(waveshaperName),  
			prependArgs: [sig]
		) 
	}

	// Waveshape wraper functions used with SynthDef.wrap
	*getWaveshapeWrapper{|name|

		if(
			waveshapeWrappers.keys.asArray.indexOfEqual(name).isNil,
			{
				M.poster("Waveshape wrapper % not found", error: true);
				^nil
			}, 
			{
				^waveshapeWrappers[name]
			}
		)
	}

	*addWaveshapeWrapper{|name, func|
		M.poster("Adding waveshape wrapper function %".format(name));
		waveshapeWrappers.put(name, func);
	}

	*shapeWrapperKinds{
		^waveshapeWrappers.keys
	}

}
