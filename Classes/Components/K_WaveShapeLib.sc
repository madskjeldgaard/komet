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

		K.poster("Adding waveshape buffer %".format(name));
		shapeBuffers.put(name, buffer);
	}

	*embedWithWaveshaper{|waveshaperName, sig|
      if(initialized != true, { this.init() });

		^SynthDef.wrap(
			K.getWaveshapeWrapper(waveshaperName),  
			prependArgs: [sig]
		) 
	}

	// Waveshape wraper functions used with SynthDef.wrap
	*getWaveshapeWrapper{|name|

		if(
			waveshapeWrappers.keys.asArray.indexOfEqual(name).isNil,
			{
				K.poster("Waveshape wrapper % not found", error: true);
				^nil
			}, 
			{
				^waveshapeWrappers[name]
			}
		)
	}

	*addWaveshapeWrapper{|name, func|
		K.poster("Adding waveshape wrapper function %".format(name));
		waveshapeWrappers.put(name, func);
	}

	*shapeWrapperKinds{
		^waveshapeWrappers.keys
	}

}
