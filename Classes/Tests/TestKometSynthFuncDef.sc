// TODO: add, check
TestKometSynthFuncDef : KometTest {

    test_initializedCorrectly{
        var func = {|freq| SinOsc.ar(freq)};
        var type = \synth;
        var category = \testcategory;
        var basename = \testbase;
        var numChans = 2;
        var desc = "This is a description of a test synth";
        var specs = (freq: Spec.specs[\freq] );
        var sd = KometSynthFuncDef(
            basename,
            func,
            type,
            category,
            numChans,
            desc,
            specs,
        );

        // this.assert(sd.name == basename, "komet synthdef name set correctly");
        // this.debug(sd.name);
        this.assert(sd.category == category, "komet synthdef category set correctly");
        // this.debug(sd.category);
        this.assert(sd.type == type, "komet synthdef type set correctly");
        // this.debug(sd.type);
        this.assert(sd.func == func, "komet synthdef func set correctly");
        // this.debug(sd.func);
        this.assert(sd.text == desc, "komet synthdef desc set correctly");
        // this.debug(sd.text);
        this.assert(sd.specs == specs, "komet synthdef specs set correctly");
        // this.debug(sd.specs);
    }
}
