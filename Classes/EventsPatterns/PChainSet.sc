PChainSynthSet {
    *new{|chain, synthIndex, setArgs|
        ^super.new.init(chain, synthIndex, setArgs)
    }

    init{|chain, synthIndex, setArgs|
        var nodeID = chain[synthIndex][\node].nodeID;
        var argKeys = setArgs.asDict.keys.asArray;
        var pbindPairs = [\type, \set, \id, nodeID, \args, argKeys] ++ setArgs;
        Log(\komet).debug("Setting PChainSet with args: %", pbindPairs);
        ^Pbind(*pbindPairs)
    }
}

+AbstractKometChain{
    psetAt{|index ... pbindPairs|
        var pdefname = this.name.asString ++ "_pchainsynthset_" ++ index;
        // TODO: Rewrite to use PatternProxy instead as to not pollute Pdef namespace
        data[index][\pattern] = data[index][\pattern] ?? { PatternProxy.new };
        data[index][\pattern].source = PChainSynthSet(
            this,
            index,
            pbindPairs
        );

        data[index][\pattern].play
    }
}
