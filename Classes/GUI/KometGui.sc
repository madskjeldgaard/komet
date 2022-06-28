KometGui{
    *new{
        var title = "KometGUI";
        var win = Window.new(title);
        var layout = VLayout(
            StaticText(win).string_(title),
            HLayout(
                Button.new(win).states_([["Browse synths"]]).action_({
                    Komet.browse()
                }),
                this.prLogLevel(win)

            ),
            this.prTransport(win),
            this.prChainButtons(win)
        );
        win.layout = layout;
        win.front;
    }

    *prLogLevel{|win|
        ^HLayout(
            StaticText(win)
            .string_("Log level: "),
            Button.new(win)
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
        ^HLayout(
            Button.new(parent).states_([
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
            Button.new(parent).states_([
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
            StaticText.new(parent).string_("Volume:"),
            Slider.new(parent)
            .orientation_(\vertical)
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
            Button.new(parent)
            .states_([
                [chain.name]
            ])
            .action_({|obj|
                var val = obj.value;
                KometMainChain.all[index].gui;
            })

        }.asArray;

        chainButtons = [
            StaticText.new(parent).string_("Chains:").font_(Font.default.bold_(true))
        ] ++ chainButtons;
        ^VLayout.new(*chainButtons);
    }

}
