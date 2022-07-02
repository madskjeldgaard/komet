AbstractKometChain : Singleton{
    classvar fxItemSize=3;
    classvar freeBeforePlay=true;
    var <fxChain, <numChannels, <server, <group, <addAfter;
    var <data;
    var <initialized;

    set{|fxchain, numchannels, addAfterNode|
            if(
                fxchain.isArray &&
                fxchain.notNil &&
                numchannels.notNil, {

                    if(KometFXFactory.initialized.not || (KometSynthLib.global[\fx].size == 0), {
                        Log(\komet).warning( "%: KometFXFactory not initialized. Building it now", this.class.name);
                        KometFXFactory.new(KometChannels.new(numchannels), true);
                    });

                    // Prioritize new node, otherwise value in instance and then group 1 as default
                    addAfter = addAfterNode ? addAfter ? 1;

                    Log(\komet).debug("%, setting Singleton", this.class.name);

                    fxChain = fxchain;
                    numChannels = numchannels;

                    if(KometFXFactory.initialized.not, {
                        KometFXFactory.new(numChannels)
                    });

                    if(freeBeforePlay, {
                        this.free();
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
        if(newChain.every{|fxitem| fxitem.class == KometFXItem} or: { newChain.size == 0}, {
            // FIXME: do we want to carry over synth args from previous synths or clear them?
            newChain.do{|fxItem, index|
                if(fxItem.class == KometFXItem, {
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
                            data[index][\args] = args.asDict;
                            data[index][\fxName] = name;
                            data[index][\fxType] = type;
                            data[index][\node] = nil;
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
        data[index][\args] = data[index][\args] ++ newArgs.asDict;
        args = data[index][\args].asKeyValuePairs;

        Log(\komet).debug("Setting synth at index % with args %", index, args);
        this.synthAt(index).set(*args)

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

    initializeAllNodes{
        Log(\komet).debug("initializing nodes for %", this.class.name);
        data.do { |dataItem, index|
            var synthDefName = KometSynthLib.at(
                \fx,
                dataItem[\fxType],
                dataItem[\fxName],
                \synthDefName
            );

            var args = dataItem[\args];

            data[index][\node] = Synth(
                synthDefName,
                args,
                target: group,
                addAction: \addToTail
            );

            this.setSynthAt(index, args);
        }
    }
}
