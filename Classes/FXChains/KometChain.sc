KometChain : AbstractKometChain {
    classvar <>addAction=\addAfter;
    classvar <>freeBeforePlay=false;

    init{
        Log(\komet).debug("%, initializing Singleton", this.class.name);
        initialized = false;
        data = data ?? [];

        server = Server.local;

        ServerTree.add(this, server); // synth node tree init
        CmdPeriod.add(this);
    }

    play {
        Log(\komet).debug("Initializing server tree for %", this.class.name);

        // server.makeBundle(nil, {
        forkIfNeeded{
            group = Group.new(target: addAfter, addAction: addAction);
            server.sync;
            this.initializeAllNodes();

        }
        // })
    }
}
