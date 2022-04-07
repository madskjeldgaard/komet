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
  var supportedOrders = [\O1,\O2,\O3,\O4,\O5,\O6,\O7];

    // If the output is a number it will be assumed to be "normal" output (stereo, azimuth, mono)
    // If a symbol, it will try to find an ambisonics encoder
    ^if(output.isNumber, {
      case
      // Mono output
      {output == 1} {
        if(numChannelsIn > 1, { \stereo2mono }, { \mono2mono })
      }

      // Stereo output
      {output == 2} {
        case
        { numChannelsIn == 1 } { \mono2stereo }
        { numChannelsIn == 2 } { \stereo2stereo };
      }

      // Azimuth output
      {output > 2} {
        if( numChannelsIn == 1, { \mono2azimuth }, { \multi2azimuth })
      }
    }, {

      // Ambisonics output - check if the symbol is a supported order
      if(
          output.isKindOf(Symbol) && supportedOrders.any({|supportedOrder|
              output == supportedOrder
          }),
          {
              case
              {numChannelsIn == 1} {
                  ^switch (output,
                      \O1, { \mono2hoaO1 },
                      \O2, { \mono2hoaO2 },
                      \O3, { \mono2hoaO3 },
                      \O4, { \mono2hoaO4 },
                      \O5, { \mono2hoaO5 },
                      \O6, { \mono2hoaO6 },
                      \O7, { \mono2hoaO7 },
                  );
              }

              {numChannelsIn == 2} {
                  ^switch (output,
                      \O1, { \stereo2hoaO1 },
                      \O2, { \stereo2hoaO2 },
                      \O3, { \stereo2hoaO3 },
                      \O4, { \stereo2hoaO4 },
                      \O5, { \stereo2hoaO5 },
                      \O6, { \stereo2hoaO6 },
                      \O7, { \stereo2hoaO7 },
                  );
              };

              if(numChannelsIn > 2, { "num channels in has to be 1 or 2 channels for HOA in M".error});

          }, {
        "% got erronous argument for output: % should be either an integer or a symbol (one of %)".format(this.name, output, supportedOrders).error
      })

    });
  }
}
