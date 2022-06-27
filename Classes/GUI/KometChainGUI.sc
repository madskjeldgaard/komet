/*
*
* TODO:
*
* - Use MPV
* - Set sliders to initial value
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

            VLayout(name, HLayout(* sliders))

        }.asArray;

        // chainButtons = [StaticText.new(win).string_("Chains:")] ++ chainButtons;
        layout = VLayout.new(*chainButtons);
        win.layout = layout;
        win.front;
    }
}
