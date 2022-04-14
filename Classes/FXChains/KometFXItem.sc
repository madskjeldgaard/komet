// A convenience function to make sure the correct arguments are passed to fx chains
KometFXItem[slot] {
    var <data;
    classvar <maxSize=3;

    *new{|fxName, fxType, fxArgs|
        ^super.new.init(fxName, fxType, fxArgs)
    }

    init{|fxName, fxType, fxArgs|
        ^if(
            fxName.isKindOf(Symbol) &&
            fxType.isKindOf(Symbol) &&
            fxArgs.isKindOf(SequenceableCollection), {
                data = Array.newClear(3);
                data.put(0, fxName);
                data.put(1, fxType);
                data.put(2, fxArgs);
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
}
