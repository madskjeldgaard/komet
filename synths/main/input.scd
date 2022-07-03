(
var desc = "Input 1 channel",
func = {|dur, inputbus=0|
    SoundIn.ar(bus:inputbus)
},
    type = \synth,
    category = \synthetic,
    basename = \input1,
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
