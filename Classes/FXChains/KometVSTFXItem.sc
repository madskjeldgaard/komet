// A convenience function to make sure the correct arguments are passed to fx chains when using VSTPlugin
KometVSTFXItem[slot] {
    classvar <maxSize=6;
    var <data;

    *new{|fxName, fxType, fxArgs, vstname, vstArgs, editor=false|
        ^super.new.init(fxName, fxType, fxArgs, vstname, vstArgs, editor)
    }

    init{|fxName, fxType, fxArgs, vstname, vstArgs, editor|
        ^if(
            fxName.isKindOf(Symbol) &&
            fxType.isKindOf(Symbol) &&
            (vstname.isKindOf(Symbol) or: { vstname.isKindOf(String) }) &&
            (fxArgs.isKindOf(SequenceableCollection) or: { fxArgs.isNil }) &&
            (vstArgs.isKindOf(SequenceableCollection) or: { vstArgs.isNil }) &&
            editor.isKindOf(Boolean)
            , {
                data = Array.newClear(maxSize);
                data.put(0, fxName);
                data.put(1, fxType);
                data.put(2, fxArgs);
                data.put(3, vstname);
                data.put(4, vstArgs);
                data.put(5, editor);
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

    vstArgs{
        ^this.at(4)
    }

    editor{
        ^this.at(5)
    }
}
