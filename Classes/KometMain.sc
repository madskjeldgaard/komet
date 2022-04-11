// TODO: Specs and gui
// Inspiration:
// https://github.com/musikinformatik/SuperDirt/classes/DirtOrbit.sc

// TODO: remove, preset
KometMainChain : Singleton{
    var <fxChain, <numChannels, <server, <group, <addAfter;
    var <data;

    init{
        Log(\komet).debug("%, initializing Singleton", this.class.name);

        data = data ?? [];
        server = Server.local;
        group = server.nextPermNodeID;
        ServerTree.add(this, server); // synth node tree init
        CmdPeriod.add(this);

    }

    set{|fxchain, numchannels, addAfterNode|
        var newChain = fxchain != fxChain;
        addAfter = addAfterNode;

        Log(\komet).debug("%, setting Singleton", this.class.name);

        fxChain = fxchain;
        numChannels = numchannels;

        // FIXME: do we want to carry over synth args from previous synths or clear them?
        fxChain.do{|fxItem, index|
            var name = fxItem[0];
            var type = fxItem[1];
            var args = fxItem[2] ? [];

            if(index > (data.size - 1), {
                Log(\komet).debug("%, adding data at index %", this.class.name, index);
                data = data.add(IdentityDictionary.new)
            });

            //  Converting to dict ensures no duplicates when setting new args
            data[index][\args] = args.asDict;
            data[index][\fxName] = name;
            data[index][\fxType] = type;
            data[index][\node] = nil;
        };

        if(KometFXFactory.initialized.not, {
            KometFXFactory.new(numChannels)
        });

        if(newChain, {
            Log(\komet).debug("New chain detected");
            this.initNodeTree;
        });
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

    setArgsAt{|index ... newArgs|
        var args;
        data[index][\args] = data[index][\args] ++ newArgs.asDict;
        args = data[index][\args].asKeyValuePairs;

        Log(\komet).debug("Setting synth at index % with args %", index, args);
        this.synthAt(index).set(*args)
    }

    doOnServerTree {
        // on node tree init:
        this.initNodeTree
    }

    cmdPeriod {
        Log(\komet).debug("CmdPeriod called for %", this.class.name);
    }

    initNodeTree {
        Log(\komet).debug("Initializing server tree for %", this.class.name);

        // Free existing nodes (only used when reinitializing the Singleton)
        data.do{|dataItem|
            var thisNode = dataItem[\node];
            if(thisNode.notNil, {thisNode.free}
            )
        };

        server.makeBundle(nil, { // make sure they are in order
            server.sendMsg("/g_new", group, 3, addAfter);

            data.do { |dataItem, index|
                var synthDefName = KometFXFactory.get(
                    basename:dataItem[\fxName],
                    type:dataItem[\fxType]
                );

                var args = dataItem[\args];

                data[index][\node] = Synth(
                    synthDefName,
                    args,
                    target: group,
                    addAction: \addToTail
                );
            }
        })
    }
}
