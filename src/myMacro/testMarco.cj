macro package myMacro

from std import ast.*
from std import collection.*

public macro funcMarco(input: Tokens): Tokens {
    let decl = ParseDecl(input).asFuncDecl()
    return quote(
        public func myfun() {
            return 0
        }
    )
}

public macro classMarco(input: Tokens): Tokens {
    let decl = ParseDecl(input)
    var list = checkVars(decl.asClassDecl())
    var retValues = ""

    for (name in list) {
        retValues += ":" + name
    }

    return quote(
        public func myfun1(): String {
            return $retValues
        }
    )
}

func checkVars(classDecl: NodeFormat_ClassDecl): ArrayList<String> {
    var varVisitor = ClassMemeberDeclVisitor()
    Walker.walk(classDecl, varVisitor)
    return varVisitor.getVarList()
}

class ClassMemeberDeclVisitor <: Visitor {
    private var varList: ArrayList<String> = ArrayList()

    public func getVarList(): ArrayList<String> {
        return this.varList
    }

    override public func visitDecl(decl: Decl): Bool {
        if (decl.isVarDecl()) {
            varList.add(decl.asVarDecl().getIdentifier().value)
        }
        
        return true
    }
}


