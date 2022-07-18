AbstractKometChain : Singleton{
    classvar fxItemSize=3;
    classvar freeBeforePlay=true;
    var <skipJack;
    var <fxChain, <numChannels, <server, <group, <addAfter;
    var <data;
    var <initialized;

    set{|fxchain, numchannels, addAfterNode|
            if(
                fxchain.isArray &&
                fxchain.notNil, {

                    if(KometFXFactory.initialized.not || (KometSynthLib.global[\fx].size == 0), {
                        Log(\komet).warning( "%: KometFXFactory not initialized. Building it now", this.class.name);
                        KometFXFactory.new(KometChannels.new(numchannels), true);
                    });

                    // Prioritize new node, otherwise value in instance and then group 1 as default
                    addAfter = addAfterNode ? addAfter ? 1;

                    Log(\komet).debug("%, setting Singleton", this.class.name);

                    fxChain = fxchain;
                    numChannels = numchannels ? Komet.numChannels;

                    if(freeBeforePlay, {
                        this.free();
                    });

                    if(data.size > 0, {
                        Log(\komet).debug( "%: data not empty, clearing it before setting new chain.".format( this.class.name));
                        this.clear();
                    });

                    this.setFXChain(fxchain);
                    fxchain.do{|fx, thisindex|
                        this.setSynthAt(thisindex, *fx.args)
                    };

                    initialized = true;
                }, {
                    Log(\komet).error("Incorrect arguments in set in %. Skipping...", this.class.name)

            }
        )

        }

    init{
        Log(\komet).debug("%, initializing Singleton", this.class.name);
        initialized = false;
        data = data ?? [];

        server = Server.local;
        group = server.nextPermNodeID;

        ServerTree.add(this, server); // synth node tree init
        CmdPeriod.add(this);
    }

    free{
        data.do{|dataItem, index|
            var thisNode = dataItem[\node];
            if(thisNode.notNil, {
                Log(\komet).debug("%: Freeing %", this.class.name, dataItem[\fxName]);
                thisNode.free;
                data[index][\node] = nil;
            })
        }
    }

    clear{
        data = [];
    }

    psetAt{|index ... pbindPairs|
        data[index][\pattern] = data[index][\pattern] ?? { PatternProxy.new };
        data[index][\pattern].source = PChainSynthSet(
            this,
            index,
            pbindPairs
        );

        data[index][\pattern].play
    }

    pstopAt{|index|
        data[index][\pattern].stop()
    }

    // TODO: TEST
    addFX{|fxItem, addTo=\tail|
        if(fxItem.class == KometFXItem, {
            this.free();
            switch (addTo,
                \tail, {
                    this.setFXChain(fxChain ++ [fxItem])
                },
                \head, {
                    this.setFXChain([fxItem] ++ fxChain)
                }
            );

        })
    }

    // TODO: TEST
    removeFX{|indexOfFX|
        if(indexOfFX < fxChain.size, {
            Log(\komet).debug("%, removing fx at index %", this.class.name, indexOfFX);
            this.free();
            this.setFXChain(fxChain.reject{|item, index| index == indexOfFX })
        })
    }

    setFXChain{|newChain|
        this.clear();
        if(newChain.every{|fxitem| fxitem.class == KometFXItem or: { fxitem.class == KometVSTFXItem }} or: { newChain.size == 0}, {
            // FIXME: do we want to carry over synth args from previous synths or clear them?
            newChain.do{|fxItem, index|
                if(fxItem.class == KometFXItem or: { fxItem.class == KometVSTFXItem }, {
                    var name = fxItem.name;
                    var type = fxItem.type;
                    var args = fxItem.args;

                    if(KometFXFactory.initialized, {
                        if(KometSynthLib.at(\fx, type, name).isNil.not, {

                            if(index > (data.size - 1), {
                                Log(\komet).debug("%, adding data at index %", this.class.name, index);
                                data = data.add(IdentityDictionary.new)
                            });

                            //  Converting to dict ensures no duplicates when setting new args
                            data[index][\args] = (args ? []).asDict;
                            data[index][\fxName] = name;
                            data[index][\fxType] = type;
                            data[index][\node] = nil; // Node is set using the -initializeAllNodes method

                            if(fxItem.class == KometVSTFXItem, {
                                data[index][\vstname] = fxItem.vstname;
                                data[index][\isVST] = true;
                                data[index][\vstcontroller] = nil; // This will contain the actual controller, used by -initializeAllNodes
                            }, {
                                data[index][\vstname] = nil;
                                data[index][\isVST] = false;
                                data[index][\vstcontroller] = nil;
                            });

                        }, {
                            Log(\komet).error(
                                "%: basename % / type % does not exist",
                                this.class.name,
                                name,
                                type
                            )
                        })
                    }, {
                        Log(\komet).error(
                            "%: KometFXFactory not intialized... can't add fx chain",
                            this.class.name,
                        )
                    })
                }, {
                    Log(\komet).warning("FXItem at index % does not contain the correct amount of items (%). Skipping it", index, fxItemSize)
                })
            };

            fxChain = newChain;

            this.free(); this.play();
        })
    }

    at{|index|
        ^if(index > (data.size - 1), {
            Log(\komet).error("Index does not exist");
            nil
        }, {
            data[index]
        })
    }

    synthAt{|index|
        ^this.at(index)[\node]
    }

    argsAt{|index|
        ^this.at(index)[\args].asKeyValuePairs
    }

    setSynthAt{|index ... newArgs|
        if(Server.local.hasBooted, {
            var args;
            if(data[index].isNil.not, {

                if(data[index][\args].isNil.not, {
                    data[index][\args] = (data[index][\args] ++ newArgs).asDict;
                }, {
                    data[index][\args] = newArgs.asDict;
                });

                args = (data[index][\args] ? ()).asKeyValuePairs;

                Log(\komet).debug("Setting synth at index % with args %", index, args);

                if(this.synthAt(index).notNil, {
                    this.synthAt(index).set(*args)
                }, {
                    Log(\komet).warning("Could not find synth at index % ".format(index));
                });

            }, {
                Log(\komet).warning("Could not find any data at index % ".format(index));
            })

        }, {
            Log(\komet).warning("%: Server hasn't booted", this.class.name);
        })
    }

    doOnServerTree {
        Log(\komet).debug("ServerTree init called for %", this.class.name);
    }

    cmdPeriod {
        Log(\komet).debug("CmdPeriod called for %", this.class.name);
    }

    play {
        this.subclassResponsibility(thisMethod);
    }

    // Used to poll the parameters of a vst plugin
    startSkipJack{

        // This function will poll the VST Plugin's parameters
        // FIXME: This could definately be more effective
        var updateFunc = {
            data.do{|dataItem, index|
                if(dataItem[\isVST] ? false,{
                    var pgc = dataItem[\vstcontroller];
                    var numParams = pgc.numParameters;

                    dataItem[\vstArgs] = dataItem[\vstArgs] ?? {
                        Array.newClear(numParams);
                     };

                    numParams.do{|ind|
                        pgc.get(ind, {|val|
                            // [ind, val].postln;
                            dataItem[\vstArgs][ind] =  val;
                        })
                    };

                    // Log(\komet).info( dataItem[\vstArgs]);

                })
            }
        };
        // If there is no longer a vst in the chain, stop the SkipJack function
        var stopTest = {
            data.size
            .collect{|ind| data[ind][\isVST] }
            .any{|bool| bool }
            .not
        };

        var updateInterval = 1;

        // Stop if an instance exists
        if(skipJack.notNil, {
            SkipJack.stop(this.name);
        });

        Log(\komet).debug("Starting skipjack for chain %", this.name);
        // updateFunc.value(); // Call it before starting it to get the initial values
        skipJack =  SkipJack.new(
            updateFunc:updateFunc,
            dt:updateInterval,
            stopTest:stopTest,
            name:this.name,
            autostart:true
        );

    }

    initializeAllNodes{
        var hasVST = false;
        Log(\komet).debug("initializing nodes for %", this.class.name);
        data.do { |dataItem, index|
            var synthDefName = KometSynthLib.at(
                \fx,
                dataItem[\fxType],
                dataItem[\fxName],
                \synthDefName
            );

            var args = data[index][\args];

            data[index][\node] = Synth(
                synthDefName,
                args,
                target: group,
                addAction: \addToTail
            );

            if(this.synthAt(index).isNil.not, {
                this.setSynthAt(index, args);
            }, {
                Log(\komet).error("Synth at % is nil".format(index))
            });

            // VSTPlugin
            // TODO: Server sync?
            if(data[index][\isVST], {
                Log(\komet).debug("FX Item at % is a vst: %".format(index, data[index][\vstname]));
                Server.local.sync;

                if(\VSTPluginController.asClass.notNil, {
                    var controller;
                    var vstname = data[index][\vstname];
                    // Make a controller
                    controller = \VSTPluginController.asClass.new(
                        data[index][\node]
                    );

                    // Open the plugin using the controller and the node
                    controller
                    .open(vstname,
                        action: {
                        Log(\komet).debug("Opening vst plugin %".format(vstname));

                        // Open plugin gui
                        if(data[index][\editor] ? false, {
                            controller.editor;
                        });

                        // Set parameters to old values
                        if(data[index][\vstArgs].notNil, {
                            data[index][\vstArgs].do{|val, ind|
                                controller.set(ind, val);
                            }
                        });
                    },
                    verbose: true
                );
                    data[index][\vstcontroller] = controller;
                })
            });

        };

        hasVST = data.size
            .collect{|ind| data[ind][\isVST] }
            .any{|bool| bool };

        if(hasVST, {
            Log(\komet).debug("This chain has VST (%). Setting background task".format(hasVST));
            this.startSkipJack();
        });

    }
}
