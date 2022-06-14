macro package myMacro

from std import ast.*
from std import collection.*
from encoding import json.*

public macro funcMarco(input: Tokens): Tokens {
    let decl = ParseDecl(input).asFuncDecl()
    return quote(
        public func myfunc() {
            return println("myFunc replaced")
        }
    )
}

public macro classMarco(input: Tokens): Tokens {
    let decl = ParseDecl(input).asClassDecl()
    let classModifier = decl.getModifiers()
    let classKeyWord = decl.getKeyword()
    let classIdent = decl.getIdentifier()
    let classBody = decl.getBody()
    let superTypes = decl.getSuperTypes()
    let fromJsonFunc = makeFromJsonFunc(classIdent, checkVars(decl))
    let toJsonFunc = makeToJsonFunc(classIdent)

     return quote(
        $classModifier $classKeyWord $classIdent <: $superTypes {
            $classBody
            $fromJsonFunc
            $toJsonFunc
        }
    )
}

func checkVars(classDecl: NodeFormat_ClassDecl): ArrayList<NodeFormat_VarDecl> {
    var varVisitor = ClassMemeberDeclVisitor()
    Walker.walk(classDecl, varVisitor)
    return varVisitor.getFiledInfo()
}

func makeFromJsonFunc(classIdent: Token, filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
    var jsonValues = JsonParser().parse("{\"v1\": \"String1\",\"v2\": \"String2\"}").asObject().getOrThrow()
    
    var fieldFetchToken = quote(
        var ret = $classIdent()
    )
    
    for(fieldInfo in filedInfoList) {
        //TODO: get type from getType() or init Func()
            
        var typeInfo = fieldInfo.getType().getOrThrow().asRefType().getIdentifier().value
        var identifier = fieldInfo.getIdentifier()
        var key = identifier.value
  
        match(typeInfo) {
            case "String" => fieldFetchToken = fieldFetchToken + quote(
                ret.$identifier = jsonObject.get($key).asString().getOrThrow().getValue()
            )
            case "Int64" => fieldFetchToken = fieldFetchToken + quote(
                ret.$identifier = jsonObject.get($key).asInt().getOrThrow().getValue()
            )
            case _ => ()
        }        
    }
    
    return quote(
        public func fromJson(json: String): $classIdent {
            var jsonObject = JsonParser().parse(json).asObject().getOrThrow()
            
            $fieldFetchToken
            
            return ret
        }
    )
}

func makeToJsonFunc(classIdent: Token): Tokens {
    return quote(
        public func toJson(): String {
            return ""
        }
    )
}

class ClassMemeberDeclVisitor <: Visitor {
    private var fileInfoList: ArrayList<NodeFormat_VarDecl> = ArrayList()

    public func getFiledInfo(): ArrayList<NodeFormat_VarDecl> {
        return fileInfoList
    }

    override public func visitDecl(decl: Decl): Bool {
        if (decl.isFuncDecl()) {
            //stop processing func so it won't include var declaration inside funcs
            return false
        }

        if (decl.isVarDecl()) {
            println(decl.asVarDecl().getIdentifier().value)
            println(decl.asVarDecl().getType().getOrThrow().asRefType().getIdentifier().value)
            fileInfoList.add(decl.asVarDecl())
        }
        
        return true
    }
}

record ClassFieldInfo {
    let identifier: Token
    let typeValue: NodeFormat_Type

    public init(identifier: Token, typeValue: NodeFormat_Type) {
        this.identifier = identifier
        this.typeValue = typeValue
    }
}
