(
var desc = "Silence, literally",
func = {|dur|
    Silent.ar()
},
    type = \synth,
    category = \synthetic,
    basename = \silence,
    numChans = 1,
    specs = (
    );

KometSynthFuncDef(
    basename,
    func,
    type,
    category,
    numChans,
    desc,
    specs,
).add();

)
