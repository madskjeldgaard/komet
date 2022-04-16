// Convenience function for calculating auto panning values
// When autopan is 0, it works as a normal pan using the pan argument
// When autopan is on, the pan argument becomes a bias for the autopanner

// A sort of enum used to specify modulator type in autopan
KPanShape {
    classvar <sine=0, <saw=1, <noise=2;
}

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
            pan.wrap2(2pi),
            mul: autopan,
            // add: pan
        );

        // FIXME: The pan value does not translate to the correct phase
        var saw = LFSaw.perform(rate,
            freq:panFreq,
            iphase:pan.linlin(-1.0,1.0,0.0,2.0),
            mul:autopan,
            // add:pan
        );

        var noise = LFNoise2.perform(rate,
            panFreq,
            mul:autopan,
            // add:pan.poll(label:\pan)
        );

        var shapes = [sine, saw, noise];

        panModulator = Select.perform(rate,
            panShape.clip(0, shapes.size),
            shapes
        );

        panModulator = Select.perform(rate,
            (autopan > 0.0),
            [
                DC.perform(rate, pan),
                panModulator
            ]
        );

        ^panModulator;
    }

}
