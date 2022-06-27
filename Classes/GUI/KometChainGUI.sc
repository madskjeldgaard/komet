/*
*
* TODO:
*
* - Remove fx
* - Reorder fx
* - Clear fx
* - Use MPV: https://doc.sccode.org/Classes/SimpleController.html
* - Preset
*/
KometChainGUI {

    *new{|chain|
        ^super.new.gui(chain);
    }

    gui{|chain|
        var name = chain.name;
        var win = Window.new("KometChain %".format(name));
        var layout ;

        var chainButtons = chain.data.collect{|chainData, index|
            var fxname = chainData[\fxName];
            var specsForSynth = KometSynthFuncDef(fxname).specs;
            var name = StaticText.new(win).string_(fxname).font_(Font.default.bold_(true));
            var sliders = specsForSynth.collect{|value, argName|
                var numberbox = NumberBox.new(win);
                var spec = specsForSynth[argName.asSymbol] ?? [0.0,1.0].asSpec;
                var initValue = chain.argsAt(index).asDict.at(argName) ? spec.default;

                VLayout(*[
                    StaticText.new(win).string_(argName),
                    numberbox
                    .value_(
                        initValue
                    ),
                    Slider.new(win).
                    action_({|obj|
                        var val = obj.value;

                        // Warped value
                        val = spec.map(val);
                        chain.setSynthAt(index, argName, val);
                        numberbox.value_(val);
                    })
                    .value_(
                        spec.unmap(initValue)
                    )
                ])
            }.asArray;
            VLayout(name,  HLayout(*sliders))

        }.asArray;

        var fxlist = Button.new(win).states_([["Add new fx"]]).action_({
            this.prGUIAddNewFX(chain, win)
        });

        var removeFX = Button.new(win).states_([["Remove fx"]]).action_({
            this.prGUIRemoveFX(chain, win)
        });

        // chainButtons = [StaticText.new(win).string_("Chains:")] ++ chainButtons;
        layout = VLayout.new(*[fxlist]++chainButtons);
        win.layout = layout;
        win.front;
    }

    prGUIRemoveFX{|chain, parentwin|
        // TODO
    }

    prGUIAddNewFX{|chain, parentwin|
        var name = chain.name;
        var title = "Add new FX to KometChain %".format(name);
        var win = Window.new(title);
        var possibleFX = KometSynthFuncDef.allOfType(\fx).collect{|fff| fff.name }.asArray;
        var list = ListView.new(parent:win).items_(possibleFX);
        var buttons = HLayout(
            Button.new(win).states_([["Add"]]).action_({
                var index = list.selection;
                var selectedFX = possibleFX[index][0]; // 0 index is hardcoded because this gui will return an array
                var currentChain = chain.fxChain;
                var fxItemToAdd = KometFXItem.new(selectedFX, KometSynthFuncDef(selectedFX).category, []);
                var newChain = currentChain ++ [fxItemToAdd];
                // Set new chain
                chain.class.all[chain.name].set(newChain, chain.numChannels, chain.addAfter);
                win.close();
                parentwin.close();
                this.gui(chain);
            }),
            Button.new(win).states_([["Cancel"]]).action_({
                win.close()
            }),
        );
        var layout = VLayout(StaticText(win).string_(title), list, buttons);
        win.layout = layout;
        win.front;
    }
}
