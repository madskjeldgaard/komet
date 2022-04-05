// Convenience function for calculating auto panning values
// When autopan is 0, it works as a normal pan using the pan argument
// When autopan is on, the pan argument becomes a bias for the autopanner

KAutoPan{

    *new1{ |rate, pan=1, panFreq=1, autopan=0, panShape=0.0|
        ^this.panner(rate, pan, panFreq, autopan, panShape)
    }

    *ar{|pan=1, panFreq=1, autopan=0, panShape=0.0|
        ^this.new1('ar', pan, panFreq, autopan, panShape)
    }

    *kr{|pan=1, panFreq=1, autopan=0, panShape=0.0|
        ^this.new1('kr', pan, panFreq, autopan, panShape)
    }

    *panner{|rate, pan=1, panFreq=1, autopan=0, panShape=0.0|
        var panModulator;

        var sine = SinOsc.perform(rate,
            panFreq,
            mul: autopan,
            add: pan
        );

        var saw = LFSaw.perform(rate,
            freq:panFreq,
            iphase:0.0,
            mul:autopan,
            add:pan
        );

        var noise = LFNoise2.perform(rate,
            panFreq,
            mul:autopan,
            add:pan
        );

        var shapes = [sine, saw, noise];

        panModulator = Select.perform(rate,
            panShape.clip(0, shapes.size),
            shapes
        );

        panModulator = KWrapInc.perform(rate,
            panModulator,
            (-1.0),
            (1.0)
        );

        ^panModulator;
    }

}
