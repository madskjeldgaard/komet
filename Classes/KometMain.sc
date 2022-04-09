// TODO: Specs and gui
// Use addAfterNode to allow making chains / ordering
KometMain : PersistentMainFX{
    var <>fx, <>type;

    // TODO a method is needed to create SpawnOrder
    *orderFX{|ordering|
        if(
            ordering.every{|order| order.class == Symbol } &&
            this.all.keys.asArray.includesAll(ordering), {
                // Order the synths
                var previous;
                // Put the first node after the default group
                var firstNode = 1;

                Log(\komet).info("Setting new fx order: %", ordering);

                ordering.do{|mainName, index|
                    if(index == 0, {
                        this.all[mainName].addAfterNode = firstNode;
                    }, {
                        this.all[mainName].addAfterNode = this.all[previous].synth
                    });

                    previous = mainName;

                }

        }, {
            Log(\komet).error(
                "FX ordering must be an array of symbols containing valid % singleton instances. Got: %. Available %'s: %",
                this.name,
                ordering,
                this.name,
                this.all
            )
        })
        // all.
    }

    set{|numChansOut, addAfter=1, fxName=\eq3, fxType=\channelized|
        fx = fxName;
        type = fxType;
        addAfterNode = addAfter;
        numChans = numChansOut ? numChans ? Server.local.options.numOutputBusChannels;
    }

    prepareResources{
        if(KometFXFactory.initialized.not, {
            Log(\komet).warning("KometMain: fx factory not initialized. Doing it now.");
            KometFXFactory.new(numChans)
        })
    }

    addSynthDef{
        synthdefName = KometFXFactory.get(basename:fx, type:type);
    }

    // Not used
    synthFunc{
        ^{}
    }
}
