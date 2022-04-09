/*
*
* A template class that is inherited from the actual component managers (envelopes, filters, etc)
*
* Think of it as a factory producing functions that will be used within a larger synthdef
*
* One of the special things about this clas (it seems, in hindsight) is it's ability to manage dependencies for other components

TODO: Should this be merged into KometComponentLoader ?
*/
KComponentManager {
  classvar <dependencies, <instances;
  var <name, <items, <loaded=false;

  *new {|componentName|
    ^this.createInstance(componentName)
  }

  *createInstance {|componentName|
    instances = instances ?? { IdentityDictionary.new };
    dependencies = dependencies ?? { Array.new() };

    if(instances[componentName].isNil,{
      // this.loadDependencies();
      this.loadComponents();

      instances[componentName] = super.new.init(componentName)
    });

    ^instances[componentName]
  }

  init {|componentName|
    if(componentName.isNil, { "%: No component name".format(this.asString).error });
    name = componentName;
    items = KometComponentLoader.at(componentName);
    loaded = true;
  }

  keys{
    ^items.keys
  }

  *loadComponents{
    if(KometComponentLoader.all.isNil, {
      KometComponentLoader.loadAll();
    });
  }

  // @FIXME: Can we embed the function in the function with the prefix/suffix ? To make things simpler
  // extraArgs is useful for subclasses that have extra arguments in the outer functions (like the filters)
  getFunctionForWrapper{|functionName, prefix="", suffix="" ... extraArgs|
    ^items.at(functionName).value(prefix,suffix, *extraArgs)
  }

  // functionName, prefix and suffix are passed to the function that produces the wrapper
  // Wrapper args are passed to the inner function
  getWrap{|functionName, prefix="", suffix="" ... wrapperArgs|
    var func = this.getFunctionForWrapper(functionName, prefix, suffix);
    ^SynthDef.wrap(func, prependArgs: wrapperArgs)
  }

  // @TODO unncessary??
  *loadDependencies{
    dependencies.do{|dep|
      "Trying to load dependency % for %".format(dep.asString, this.asString).postln;
      if(instances[dep].isNil, {
        dep.new();
      })
    }
  }
}
