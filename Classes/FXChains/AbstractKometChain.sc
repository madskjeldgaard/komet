AbstractKometChain : Singleton{
    classvar fxItemSize=3;
    classvar freeBeforePlay=true;
    var <fxChain, <numChannels, <server, <group, <addAfter;
    var <data;
    var <initialized;

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

    setFXChain{|newChain|
        this.clear();

        // FIXME: do we want to carry over synth args from previous synths or clear them?
        newChain.do{|fxItem, index|
            if(fxItem.class == KometFXItem, {
                var name = fxItem.name;
                var type = fxItem.type;
                var args = fxItem.args;

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
                Log(\komet).warning("FXItem at index % does not contain the correct amount of items (%). Skipping it", index, fxItemSize)
            })
        };

    }

    set{|fxchain, numchannels, addAfterNode|
        if(
            fxchain.isArray &&
            fxchain.notNil &&
            numchannels.notNil, {

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
            this.play;
            fxchain.do{|fx, thisindex|
                this.setSynthAt(thisindex, *fx.args)
            };

            initialized = true;
        }, {
            Log(\komet).error("Incorrect arguments in set in %. Skipping...", this.class.name)
        })

    }

    at{|index|
        ^if(index > (data.size - 1), {
            Log(\komet).error("Index does not exist");
        }, {
            data[index]
        })
    }

    synthAt{|index|
        ^this.at(index)[\node]
    }

    argsAt{|index|
        ^this.at(index)[\args]
    }

    setSynthAt{|index ... newArgs|
        var args;
        data[index][\args] = data[index][\args] ++ newArgs.asDict;
        args = data[index][\args].asKeyValuePairs;

        Log(\komet).debug("Setting synth at index % with args %", index, args);
        this.synthAt(index).set(*args)
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
        }
    }
}
