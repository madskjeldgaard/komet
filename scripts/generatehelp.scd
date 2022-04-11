(
var outfolder = KometPath.path +/+ "HelpSource" +/+ "Classes";

SCDoc.documents.select{|doc|
    doc.isUndocumentedClass() && Komet.allClasses.includes(doc.klass)
}
.asArray
.do{|doc|
    "Generating missing help file for %".format(doc.klass).postln;

    K_SCDocGen.new(doc.klass, outfolder.fullPath);
};

"Done".postln;

0.exit
)
