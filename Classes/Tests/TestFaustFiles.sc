TestFaustFiles : UnitTest{
    // Test if faust files compile
    test_faustFilesCompile{
        this.assert(
            K.faustFiles.collect{|fff|
                "faust % > /dev/null".format(fff.fullPath).systemCmd == 0
            }.every{|bool| bool }
        )
    }
}