// A convenience function to make sure the correct arguments are passed to fx chains when using VSTPlugin
KometVSTFXItem[slot] {
    classvar <maxSize=4;
    var <data;

    *new{|fxName, fxType, fxArgs, vstname|
        ^super.new.init(fxName, fxType, fxArgs, vstname)
    }

    init{|fxName, fxType, fxArgs, vstname|
        ^if(
            fxName.isKindOf(Symbol) &&
            fxType.isKindOf(Symbol) &&
            (vstname.isKindOf(Symbol) or: { vstname.isKindOf(String) }) &&
            fxArgs.isKindOf(SequenceableCollection)
            , {
                data = Array.newClear(maxSize);
                data.put(0, fxName);
                data.put(1, fxType);
                data.put(2, fxArgs);
                data.put(3, vstname);
                this
            }, {
                Log(\komet).error("Could not make % instance", this.class.name);
                nil
            }
        );

    }

    at{|index|
        ^data[index]
    }

    name{
        ^this.at(0)
    }

    type{
        ^this.at(1)
    }

    args{
        ^this.at(2)
    }

    vstname{
        ^this.at(3)
    }

}
