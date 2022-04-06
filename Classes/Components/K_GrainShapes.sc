KGrainShapes : KComponentManager{
  var <buffers;

  *new{
    var componentName = \grainshapes;
    ^this.createInstance(componentName).createShapeBuffers();
  }

  getFunctionForWrapper{ ^nil }

  createShapeBuffers{
    buffers = buffers ?? {
      items.items.collect{|envelope|
        Buffer.sendCollection(Server.local, envelope.discretize, 1);
      }
    }  
  }

  getWrap{|prefix="", suffix=""|
    if(buffers.isNil, { this.createShapeBuffers });

    ^SynthDef.wrap({
      var grainshape = K_NC.kr("grainshape", 0.5, prefix: prefix, suffix: suffix);
      var shapebuffers = SynthDef.wrap({ buffers.asArray });
      Select.kr(
        grainshape * shapebuffers.size, 
        shapebuffers
      ); 
    })
  }

}

//*embedWithGrainShapes{
		// ^SynthDef.wrap({|grainshape=0.5|
		// 	var shapebuffers = SynthDef.wrap({ K.grainShapeBuffers.asArray });
		// 	Select.kr(
		// 		grainshape * shapebuffers.size, 
		// 		shapebuffers
		// 	); 
		// })
	// }
 // }
