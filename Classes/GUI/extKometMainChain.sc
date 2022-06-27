+KometMainChain{
    *gui{
        var win = Window.new("All KometMainChains");
        var layout ;

        var chainButtons = KometMainChain.all.collect{|chain, index|
            Button.new(win)
            .states_([
                [chain.name]
            ])
            .action_({|obj|
                var val = obj.value;
                KometMainChain.all[index].gui;
            })

        }.asArray;

        chainButtons = [StaticText.new(win).string_("Chains:")] ++ chainButtons;
        layout = VLayout.new(*chainButtons);
        win.layout = layout;
        win.front;
    }
}
