/*

This is used to add type safety to the channels argument in the bigger classes, particularly factories.

It will detect if the user inputs ambisonics or channels as the argument and is able to resolve things.

*/
KometChannels{
    classvar <orderSymbols;

    var <isAmbisonics=false;
    var chans;
    var order;
    var hoaorder;
    var <check;

    *new{|channels|
        ^super.new.init(channels)
    }

    *initClass{}

    isKometChannel{
        ^true
    }

    // Channels can either be an integer or a HoaOrder
    init{|channels|
        check = if(channels.class == HoaOrder, {
            // Assume ambisonics
            isAmbisonics = true;
            hoaorder = channels;
            order = channels.order;
            chans = channels.size;
            true
        }, {
            // Assume not ambisonics
            var res;
            res = channels.isKindOf(Number);
            if(res, {
                isAmbisonics = false;
                chans = channels;
            });
            res
        });

        if(check == false, {
            Log(\komet).error("%: channels argument incorrect or invalid".format(this.class.name))
        });
    }

    hoaOrder{
        ^if(this.isAmbisonics, {
            order
        }, {
            Log(\komet).error("%: KometChannels is not ambisonics".format(this.class.name));
            nil
        })
    }

    numChannels{
        ^if(this.isAmbisonics, {
            hoaorder.size
        }, {
            chans
        })
    }

}
