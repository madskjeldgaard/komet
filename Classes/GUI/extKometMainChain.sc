+KometMainChain{
    *gui{
        var win = KometWindow.new("All KometMainChains");
        var layout ;

        var chainButtons = KometMainChain.all.collect{|chain, index|
            KometButton.new(win)
            .states_([
                [chain.name]
            ])
            .action_({|obj|
                var val = obj.value;
                KometMainChain.all[index].gui;
            })

        }.asArray;

        chainButtons = [KometParameterText.string_("Chains:")] ++ chainButtons;
        layout = VLayout.new(*chainButtons);
        win.layout = layout;
        win.front;
    }
}
