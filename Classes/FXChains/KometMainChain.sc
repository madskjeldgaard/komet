// TODO: Specs and gui
// Inspiration:
// https://github.com/musikinformatik/SuperDirt/classes/DirtOrbit.sc

// Spawns synths in a permanent group node, respawned when ServerTree is initialized.
KometMainChain : AbstractKometChain {
    classvar freeBeforePlay=true;
    init{
        Log(\komet).debug("%, initializing Singleton", this.class.name);
        initialized = false;
        data = data ?? [];

        server = Server.local;
        group = server.nextPermNodeID;

        ServerTree.add(this, server); // synth node tree init
        CmdPeriod.add(this);
    }

    doOnServerTree {
        this.play
    }

    play {
        Server.local.doWhenBooted{
            Log(\komet).debug("Initializing server tree for %", this.class.name);

            server.makeBundle(nil, { // make sure they are in order
                server.sendMsg("/g_new", group, 3, addAfter);
                this.initializeAllNodes();
            })

        }
    }
}
