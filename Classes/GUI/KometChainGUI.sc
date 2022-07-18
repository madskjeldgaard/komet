/*
*
* TODO:
*
* - Reorder fx
* - Clear fx
* - Use MPV: https://doc.sccode.org/Classes/SimpleController.html
* - Preset
*/
KometChainGUI {
    var fxNameList, removeablefxNameList;

    *new{|chain|
        ^super.new.gui(chain);
    }

    gui{|chain|
        var name = chain.name;
        var win = KometWindow.new("KometChain %".format(name));
        var layout ;

        var chainButtons = chain.data.collect{|chainData, index|
            var fxname = chainData[\fxName];
            if(chainData[\isVST].not, {
                // Not VSST
                var specsForSynth = KometSynthFuncDef(fxname).specs;

                var name = KometSmallTitle.new(win).string_(fxname);
                var sliders = specsForSynth.collect{|value, argName|
                    var numberbox = KometNumberBox.new(win);
                    var spec = specsForSynth[argName.asSymbol] ?? [0.0,1.0].asSpec;
                    var initValue = chain.argsAt(index).asDict.at(argName) ? spec.default;

                    HLayout(*[
                        [KometParameterText(win).string_(argName), s: 3],
                        [KometSlider.new(win).
                        action_({|obj|
                            var val = obj.value;

                            // Warped value
                            val = spec.map(val);
                            chain.setSynthAt(index, argName, val);
                            numberbox.value_(val);
                        })
                        .orientation_(\horizontal)
                        .value_(
                            spec.unmap(initValue)
                        ), s: 4],
                        [numberbox
                            .value_(
                                initValue
                            ), s: 1],
                        ])
                    }.asArray;
                    VLayout(name,  VLayout(*sliders))
                }, {
                    // VST
                    var fxname = chainData[\fxName];
                    var name = KometSmallTitle.new(win).string_(fxname.asString ++ ": " ++ chainData[\vstname]);
                    VLayout(
                        name,
                        HLayout(
                            KometButton.new(win)
                            .states_([["Open VST editor"]])
                            .action_({
                                chainData[\vstcontroller].editor
                            }),
                            KometButton.new(win)
                            .states_([["Open VST gui"]])
                            .action_({
                                chainData[\vstcontroller].gui
                            }),
                        )
                    )
            })
        }.asArray;
        var fxlist, removeFX;

        // The possible list of fx to be added
        fxNameList = KometSynthFuncDef.allOfType(\fx).collect{|fff| fff.name }.asArray;

        // The list of fx that may be removed
        removeablefxNameList = chain.fxChain.collect{|ff| ff.name}.asArray;

        fxlist = KometButton.new(win).states_([["Add new fx"]]).action_({
            this.prGUIAddNewFX(chain, win)
        });

        removeFX = KometButton.new(win).states_([["Remove fx"]]).action_({
            this.prGUIRemoveFX(chain, win)
        });

        // chainButtons = [StaticText.new(win).string_("Chains:")] ++ chainButtons;
        layout = VLayout.new(*[fxlist, removeFX]++chainButtons);
        win.layout = layout;
        win.front;
    }

    prGUIRemoveFX{|chain, parentwin|
        var name, title, win, possibleFX, list, buttons, layout;
        name = chain.name;
        title = "Remove FX from KometChain %".format(name);
        win = KometWindow.new(title);
        // Refresh list of currently removeable effects
        removeablefxNameList = chain.fxChain.collect{|ff| ff.name}.asArray;
        possibleFX = removeablefxNameList;
        list = ListView.new(parent:win).items_(possibleFX);
        buttons = HLayout(
            KometButton.new(win).states_([["Remove"]]).action_({
                var index = list.selection;
                var selectedFX = possibleFX[index][0]; // 0 index is hardcoded because this gui will return an array
                chain.class.all[chain.name].removeFX(index[0]);

                win.close();
                parentwin.close();
                // Refresh list of removeables
                this.gui(chain);
            }),
            KometButton.new(win).states_([["Cancel"]]).action_({
                win.close()
            }),
        );
        layout = VLayout(KometSmallTitle(win).string_(title), list, buttons);
        win.layout = layout;
        win.front;

    }

    prGUIAddNewFX{|chain, parentwin|
        var name = chain.name;
        var title = "Add new FX to KometChain %".format(name);
        var win = KometWindow.new(title);
        var possibleFX = fxNameList;
        var list = ListView.new(parent:win).items_(possibleFX);
        var buttons = HLayout(
            KometButton.new(win).states_([["Add to tail"]]).action_({
                var index = list.selection;
                var selectedFX = possibleFX[index][0]; // 0 index is hardcoded because this gui will return an array
                var fxItemToAdd = KometFXItem.new(selectedFX, KometSynthFuncDef(selectedFX).category, []);

                chain.class.all[chain.name].addFX(fxItemToAdd, \tail);

                win.close();
                parentwin.close();
                this.gui(chain);
            }),
            KometButton.new(win).states_([["Add to head"]]).action_({
                var index = list.selection;
                var selectedFX = possibleFX[index][0]; // 0 index is hardcoded because this gui will return an array
                var fxItemToAdd = KometFXItem.new(selectedFX, KometSynthFuncDef(selectedFX).category, []);

                chain.class.all[chain.name].addFX(fxItemToAdd, \head);

                win.close();
                parentwin.close();
                this.gui(chain);
            }),
            KometButton.new(win).states_([["Cancel"]]).action_({
                win.close()
            }),
        );
        var layout = VLayout(KometSmallTitle(win).string_(title), list, buttons);
        win.layout = layout;
        win.front;
    }
}
