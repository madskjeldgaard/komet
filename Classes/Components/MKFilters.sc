KFilters : KComponentManager{
  *new {
    var componentName = \filters;
    dependencies = [\envelopes];
    ^this.createInstance(componentName)
  }

  getWrap{|functionName, prefix="", suffix="", filterEnvelopeType ... wrapperArgs|
    var func = this.getFunctionForWrapper(functionName, prefix, suffix, filterEnvelopeType);
    ^SynthDef.wrap(func, prependArgs: wrapperArgs) 
  }

}
