/*

This class takes a folder containing faust files and compiles them to SuperCollider plugins including SuperNova plugins.

It places them in the user extensions folder in a folder defined in the installTargetFolder argument.

*/

KometFaustPackage : AbstractFaustPackage{
    *initClass{
        this.autoCompileAtStartup()
    }
}
