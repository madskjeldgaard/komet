TestKometFaustFiles : KometTest{
    // Test if faust files compile
    test_faustFilesCompile{
        this.assert(
            KometSynthFactory.faustFiles.collect{|fff|
                "faust % > /dev/null".format(fff.fullPath).systemCmd == 0
            }.every{|bool| bool }
        )
    }
}
