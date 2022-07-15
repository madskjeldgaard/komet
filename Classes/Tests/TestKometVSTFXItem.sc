TestKometVSTFXItem : KometTest {
    test_data{
        var name = \eq3;
        var type = \channelized;
        var args = [\lowlevel, 3, \highlevel, 4];
        var vst = "TEOTE";
        var vstargs = [\Freq, 200];
        var editor = false;

        var item = KometVSTFXItem.new(
            fxName: name,
            fxType: type,
            fxArgs: args,
            vstname: vst,
            vstArgs:vstargs,
            editor: editor
        );

        this.assert(item.name == name, "check name");
        this.assert(item.type == type, "check type");
        this.assert(item.args == args, "check args");
        this.assert(item.vstname == vst, "check vstname");
        this.assert(item.vstArgs == vstargs, "check vstargs");
        this.assert(item.editor == editor, "check editor");

        this.assert(item.args.size == args.size, "check args size");
        this.assert(item.data.size == KometVSTFXItem.maxSize, "check data size");
    }
}
