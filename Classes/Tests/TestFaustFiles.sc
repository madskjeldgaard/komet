TestKometFaustFiles : KometTest{
    // Test if faust files compile
    test_faustFilesCompile{
        this.assert(
            KometPath.faustFilesPath.files.collect{|fff|
                Faust.isFaustFile(fff).if({
                    "faust % > /dev/null".format(fff.fullPath).systemCmd == 0
                }, {
                    true
                })
            }.every{|bool| bool }
        )
    }
}
