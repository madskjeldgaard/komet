(
var desc = "A cd skip emulator",
    func = {|in, maxDelay=2.0,autoMode=1,autoSpeed=1,skipTrigger=0,resetTrigger=0,pos=0,freeze=0,clean=0|
        var sig = in;

        var lagTime = \lagTime.kr(1);
        \CDSkip.asClass.perform(\ar,
            in: sig, //.poll(label: chanNum),
            maxDelay: maxDelay,
            autoMode: autoMode,
            autoSpeed: autoSpeed.klag(lagTime),
            skipTrigger: skipTrigger,
            resetTrigger: resetTrigger,
            pos: pos,
            freeze: freeze,
            clean: clean
        )
    },
    type = \fx,
    category = \stereo,
    basename = \cdskip,
    numChans = nil, // TODO: Not used
    specs = (
        maxDelay: [0.01,100],
        autoMode: [0,1],
        autoSpeed: [0, 1],
        resetTrigger: [-1.0,1.0],
        skipTrigger: [-1.0,1.0],
        pos: [0.0,1.0], // Not entirely correct, see help file
        freeze: [-1.0,1.0],
        clean: [-1.0,1.0]
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
