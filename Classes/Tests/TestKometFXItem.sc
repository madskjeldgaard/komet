TestKometFXItem : KometTest {
    test_data{
        var name = \eq3;
        var type = \channelized;
        var args = [\lowlevel, 3, \highlevel, 4];

        var item = KometFXItem.new(
            fxName: name,
            fxType: type,
            fxArgs: args
        );

        this.assert(item.name == name, "check name");
        this.assert(item.type == type, "check type");
        this.assert(item.args == args, "check args");
        this.assert(item.args.size == args.size, "check args size");
        this.assert(item.data.size == KometFXItem.maxSize, "check data size");

    }
}
