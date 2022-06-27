// A strict datatype for specifying and containing a source synth function definition
KometSynthFuncDef : Singleton{
    classvar <supportedTypes;
    var <func,
        <type,
        <category,
        <channels,
        <text,
        <specs,
        <checkFunc;

    *allOfType{|thistype|
        ^this.all.select{|synt| synt.type == thistype }
    }

    *initClass{
        supportedTypes = [\fx, \synth]
    }

    *addAll{
        all.do{|instance|
            instance.addAll()
        }
    }

    play{|...args|
        switch (type,
            \fx, {
                var sd = KometSynthLib.at(type, category, this.name, \synthDefName);
                if(sd.notNil, {
                    Synth.after(1, sd, args);
                }, {
                    Log(\komet).error("Could not find synthdef")
                })

            },
            \synth, {
                var env = \gate;
                var filter = \none;
                var sd = KometSynthLib.at(type, category, env, filter, this.name, \synthDefName);
                if(sd.notNil, {
                    Synth(sd, [\gate, 1, \dur, 1.0] ++ args);
                }, {
                    Log(\komet).error("Could not find synthdef")
                })
            }
        );
    }

    set{|synthfunc, synthtype, cat,  numOutputChannels, description, controlspecs, check|
        var mandatoryArgsUsed = [
            synthfunc,
            synthtype,
            cat,
            description,
            controlspecs,
        ].every{|aaa|
            aaa.notNil
        };

        var checks =
        (
            mandatoryArgsUsed: mandatoryArgsUsed,
            synthfuncType: synthfunc.isKindOf(Function),
            synthtypeType: synthtype.isKindOf(Symbol),
            supportedTypes: supportedTypes.includes(synthtype),
            categoryType: cat.isKindOf(Symbol),
            descType: description.isString,
            specsType: controlspecs.isKindOf(Dictionary) &&
            controlspecs.every{|spec| spec.asSpec.notNil }
        );

        checks.keysValuesDo{|checkname, res| if(res.not, { Log(\komet).error("Check failed in % for %", this.class.name, checkname) })};
        checks = checks.every{|ch| ch; };

        ^if(checks, {
            Log(\komet).debug("Setting synthdeffunc %", this.name);

            func = synthfunc;
            type = synthtype;
            category = cat;
            channels = numOutputChannels;
            text = description;
            specs = controlspecs.collect{|spec|
                if(spec.isKindOf(Symbol), {
                    KometSpecs.specs[spec] ?? Spec.specs[spec]
                }, {
                    spec.asSpec
                })
            };
            checkFunc = check;

            // To avoid duplicates
            // name = name.asString ++ type.asString ++ category.asString ++ channels.asString;

            if(all.keys.includes(name), {
                Log(\komet).info("Warning: % already exists for key %. Overwriting it.", this.class.name, name);
            });

            this
        },{
            Log(\komet).error("Not all mandatory arguments used or the ones used are the wrong type. Reminder, here are the arguments of the method: %", thisMethod.argNames);
            nil
        })
    }

    check{
        ^if(checkFunc.isNil, { true }, { checkFunc.value() })
    }

    // TODO: Make sure components are loaded
    add{
        switch(type,
            \fx, {
                KometFXFactory.load(this)
            },
            \synth, {
                KometSynthFactory.load(this)
            }
        );

    }

    synthdefName{|...args|
        var out = "komet";
        ([type, this.name, category, channels] ++ args).do{|thisArg|
            if(thisArg.notNil, {
                out = out ++ "_" ++ thisArg.asString;
            })
        };

        ^out.asSymbol

    }
}
