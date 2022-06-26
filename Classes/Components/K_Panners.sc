KPanners : KComponentManager{

  *new{
    var componentName = \panners;
    ^this.createInstance(componentName)
  }

  getWrap{|numChannelsIn, output, prefix="", suffix="" ... wrapperArgs|
    var func = this.getFunctionForWrapper(numChannelsIn, output, prefix, suffix);
    ^SynthDef.wrap(func, prependArgs: wrapperArgs)
  }

  getFunctionForWrapper{|numChannelsIn, output, prefix="", suffix="" ... extraArgs|
    var functionName = this.choosePanAlgo(numChannelsIn, output);

    ^items.at(functionName).value(prefix,suffix, *extraArgs)
  }

  choosePanAlgo{|numChannelsIn, output|
    // If the output is a number it will be assumed to be "normal" output (stereo, azimuth, mono)
    // If a symbol, it will try to find an ambisonics encoder
    ^if(output.isAmbisonics.not, {
        case
        // Mono output
        {output.numChannels == 1} {
            if(numChannelsIn > 1, { \stereo2mono }, { \mono2mono })
        }

        // Stereo output
        {output.numChannels == 2} {
            case
            { numChannelsIn == 1 } { \mono2stereo }
            { numChannelsIn == 2 } { \stereo2stereo };
        }

        // Azimuth output
        {output.numChannels > 2} {
            if( numChannelsIn == 1, { \mono2azimuth }, { \multi2azimuth })
        }
    }, {
        // Ambisonics output - check if the symbol is a supported order
        case
        {numChannelsIn == 1} {
            ^switch (output.hoaOrder(),
            1, { \mono2hoaO1 },
            2, { \mono2hoaO2 },
            3, { \mono2hoaO3 },
            4, { \mono2hoaO4 },
            5, { \mono2hoaO5 },
            6, { \mono2hoaO6 },
            7, { \mono2hoaO7 })
        }
        {numChannelsIn == 2} {
            ^switch (output.hoaOrder(),
            1, { \stereo2hoaO1 },
            2, { \stereo2hoaO2 },
            3, { \stereo2hoaO3 },
            4, { \stereo2hoaO4 },
            5, { \stereo2hoaO5 },
            6, { \stereo2hoaO6 },
            7, { \stereo2hoaO7 })
        };

        // if(numChannelsIn > 2, { "num channels in has to be 1 or 2 channels for HOA in M".error});

    })

  }
}
