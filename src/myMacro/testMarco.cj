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
    let varDeclList = checkVars(decl)
    let fromJsonFunc = makeFromJsonFunc(classIdent, varDeclList)
    let toJsonFunc = makeToJsonFunc(varDeclList)

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
    return quote(
        public static func fromJson(json: String): $classIdent {
            var jsonObject = JsonParser().parse(json).asObject().getOrThrow()
            
            var ret = $classIdent()

            $(parseJsonFields(filedInfoList))
            
            return ret
        }
    )
}

func parseJsonFields(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
    var fieldParseToken = Tokens()
    
    for(fieldInfo in filedInfoList) {
        fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo)              
    }

    return fieldParseToken
}

func parseJsonFiled(fieldInfo: NodeFormat_VarDecl): Tokens {
    //TODO: get type from getType() or init Func()
    let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)

    let tokens: Tokens = match(typeInfo) {
        case "String" =>  quote(
            ret.$identifier = jsonObject.get($name).asString().getOrThrow().getValue()
        )
        case "Int64" => quote(
            ret.$identifier = jsonObject.get($name).asInt().getOrThrow().getValue()
        )
        case _ => Tokens()
    }  

    return tokens
}

func makeToJsonFunc(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
    //var compsedMap = composeMap(filedInfoList)
    return quote(
        public func toJson(): String {
            var map: HashMap<String, JsonValue> = HashMap()

            $(composeMap(filedInfoList))

            return JsonObject(map).toString()

        }
    )
}

func composeMap(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
    var fileMapToken = Tokens()
    
    for(fieldInfo in filedInfoList) {
        //TODO: get type from getType() or init Func()
        fileMapToken = fileMapToken + addFieldToMap(fieldInfo)   
    }

    return fileMapToken
}

func addFieldToMap(fieldInfo: NodeFormat_VarDecl): Tokens {
    let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)

    let tokens: Tokens = match(typeInfo) {
        case "String" => quote(
            map.put($name, JsonString(this.$identifier))
        )
        case "Int64" => quote(
            map.put($name, JsonInt(this.$identifier))
        )
        case _ => Tokens()
    }

    return tokens
}

func getFieldInfo(fieldInfo: NodeFormat_VarDecl): (Token, String, String) {
    var typeInfo = fieldInfo.getType().getOrThrow().asRefType().getIdentifier().value
    var identifier = fieldInfo.getIdentifier()
    var name = identifier.value

    return (identifier, name, typeInfo)
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
            //println(decl.asVarDecl().getIdentifier().value)
            //println(decl.asVarDecl().getType().getOrThrow().asRefType().getIdentifier().value)
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
