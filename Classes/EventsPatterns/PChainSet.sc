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
