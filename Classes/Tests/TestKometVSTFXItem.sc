TestKometVSTFXItem : KometTest {
    test_data{
        var name = \eq3;
        var type = \channelized;
        var args = [\lowlevel, 3, \highlevel, 4];
        var vst = "TEOTE";

        var item = KometVSTFXItem.new(
            fxName: name,
            fxType: type,
            fxArgs: args,
            vstname: vst
        );

        this.assert(item.name == name, "check name");
        this.assert(item.type == type, "check type");
        this.assert(item.args == args, "check args");
        this.assert(item.vstname == vst, "check vstname");
        this.assert(item.args.size == args.size, "check args size");
        this.assert(item.data.size == KometVSTFXItem.maxSize, "check data size");
    }
}
