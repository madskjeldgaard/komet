KometGui{
    *new{
        var title = "KometGUI";
        var win = KometWindow.new(title);
        var layout = VLayout(
            // Title
            KometSmallTitle(win).string_(title),

            // Browse
            VLayout(
                KometButton.new(win).states_([["Browse synths"]]).action_({
                    Komet.browse()
                }),
                this.prLogLevel(win)

            ),

            // Record, mute, vol etc
            this.prTransport(win),

            // Effect chains
            this.prChainButtons(win)
        );
        win.layout = layout;
        win.front;
    }

    *prLogLevel{|win|
        ^HLayout(

            // Mode
            KometParameterText.new(win).string_("Mode: "),KometParameterText.new(win).string_(Komet.mode),

            KometParameterText(win)
            .string_("Log level: "),
            KometButton.new(win)
            .states_(Log.levels.keys.asArray.collect{|lvl| [lvl]})
            .action_({|obj|
                var levels = Log.levels.keys.asArray;
                Komet.logLevel(levels[obj.value])
            })
            .value_(
                Log.levels.keys.asArray.indexOfEqual(Log(\komet).level)
            )
        )
    }

    *prTransport{|parent|
        ^VLayout(
            KometButton.new(parent).states_([
                ["Plot NodeTree"],
            ]).action_({|obj|
                var val = obj.value;
                Server.local.plotTree
            }),
            KometButton.new(parent).states_([
                ["Mute"],
                ["Unmute"],
            ]).action_({|obj|
                var val = obj.value;

                if(obj.value == 1, {
                    Server.local.mute()
                }, {
                    Server.local.unmute()
                })
            }),
            KometButton.new(parent).states_([
                ["Record"],
                ["Stop recording"],
            ]).action_({|obj|
                var val = obj.value;

                if(obj.value == 1, {
                    Komet.record()
                }, {
                    Komet.stopRecording()
                })
            }),
            KometParameterText.new(parent).string_("Volume:"),
            KometSlider.new(parent)
            .orientation_(\horizontal)
            .action_({|obj|
                var db = Spec.specs[\db].map(obj.value);
                Server.local.volume.volume_(db)
            })
            .value_(
                Spec.specs[\db].unmap(Server.local.volume.volume)
            )

        )
    }

    *prChainButtons{|parent|
        var layout;
        var chainButtons = KometMainChain.all.collect{|chain, index|
            KometButton.new(parent)
            .states_([
                [chain.name]
            ])
            .action_({|obj|
                var val = obj.value;
                KometMainChain.all[index].gui;
            })

        }.asArray;

        chainButtons = [
            KometSmallTitle.new(parent).string_("Chains:")
        ] ++ chainButtons;

        ^VLayout.new(*chainButtons);
    }

}
