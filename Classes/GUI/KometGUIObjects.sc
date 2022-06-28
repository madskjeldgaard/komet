/*
*
* This file contains simple constructor classes that makes it easy to control the look and feel of GUI objects used in Komet.
*
*/
KometFonts{
    *base{
        ^Font.default
    }

    *default{
        ^this.base.bold_(false).size_(16)
    }

    *button{
        ^this.default.bold_(true)
    }

    *smallTitle{
        ^this.default.bold_(true).size_(20)
    }

    *parameter{
        ^this.default.size_(12)
    }
}

// Theme: https://color.adobe.com/create/color-wheel
KometColors{
    *colors{
        ^[
            Color.new255(red:25, green:60, blue:64, alpha:255-25),
            Color.new255(red:46, green:89, blue:2, alpha:255-35),
            Color.new255(red:33, green:64, blue:1, alpha:255-25),
            Color.new255(red:217, green:105, blue:65, alpha:255-85),
            Color.new255(red:166, green:43, blue:31, alpha:255-65),
        ]
    }

    *textColor{
        ^this.colors[0]
    }

    *buttonColor{
        ^this.colors[0]
    }

    *winbg{
        ^this.white()
    }

    *white{
        ^Color.new255(red:249, green:249, blue:249, alpha:254)
    }
}

KometWindow{
    *new{ arg name="",
        bounds,
        resizable = true,
        border = false,
        server,
        scroll = false;

        ^Window.new(name, bounds, resizable , border , server, scroll)
        .background_(this.bg);
    }

    *bg{
        ^KometColors.winbg
    }
}

KometSlider{
    *new{|parent, bounds|
        ^Slider
        .new(parent,bounds)
        .knobColor_(KometColors.colors[0])
        .background_(KometColors.colors[3])
    }
}

KometButton{
    *new{|parent, bounds|
        ^Button.new(parent, bounds).font_(KometFonts.default)
    }
}

KometSmallTitle{
    *new{|parent, bounds|
        ^StaticText.new(parent, bounds).font_(KometFonts.smallTitle).stringColor_(KometColors.colors[0]);
    }
}

KometParameterText{
    *new{|parent, bounds|
        ^StaticText.new(parent, bounds).font_(KometFonts.parameter).stringColor_(KometColors.colors[1]);
    }
}

KometNumberBox{
    *new{|parent, bounds|
        ^NumberBox
        .new(parent, bounds)
        .background_(KometColors.winbg)
        .normalColor_(KometColors.colors[1])
        .stringColor_(KometColors.colors[0])
        .typingColor_(KometColors.colors[4])
    }
}
