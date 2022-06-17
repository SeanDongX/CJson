macro package serialization

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

public macro JsonSerializable(input: Tokens): Tokens {
    let decl = ParseDecl(input).asClassDecl()
    let classModifier = decl.getModifiers()
    let classKeyWord = decl.getKeyword()
    let classIdent = decl.getIdentifier()
    let classBody = decl.getBody()
    let superTypes = decl.getSuperTypes()
    let varDeclList = checkVars(decl)
    let fromJsonFunc = ClassJsonDeserilizer().makeFromJsonFunc(classIdent, varDeclList)
    let toJsonFunc = ClassJsonSerilizer().makeToJsonFunc(varDeclList)

     return quote(
        $classModifier $classKeyWord $classIdent <: $superTypes {
            $classBody
            $fromJsonFunc
            $toJsonFunc
        }
    )
}

func checkVars(classDecl: NodeFormat_ClassDecl): ArrayList<NodeFormat_VarDecl> {
    let varVisitor = ClassMemeberDeclVisitor()
    Walker.walk(classDecl, varVisitor)
    return varVisitor.getFiledInfo()
}


class ClassJsonSerilizer <: ClassProcessor {
    public func makeToJsonFunc(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        return quote(
            public func toJson(): String {
                var map: HashMap<String, JsonValue> = HashMap()

                $(composeMap(filedInfoList))

                return JsonObject(map).toString()

            }
        )
    }

    private func composeMap(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        var fileMapToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fileMapToken = fileMapToken + addFieldToMap(fieldInfo)   
        }

        return fileMapToken
    }

    private func addFieldToMap(fieldInfo: NodeFormat_VarDecl): Tokens {
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
}

class ClassJsonDeserilizer <: ClassProcessor {
    public func makeFromJsonFunc(classIdent: Token, filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        return quote(
            public static func fromJson(json: String): $classIdent {
                var jsonObject = JsonParser().parse(json).asObject().getOrThrow()
                
                var ret = $classIdent()

                $(parseJsonFields(filedInfoList))
                
                return ret
            }
        )
    }

    private func parseJsonFields(filedInfoList: ArrayList<NodeFormat_VarDecl>): Tokens {
        var fieldParseToken = Tokens()
        
        for(fieldInfo in filedInfoList) {
            fieldParseToken = fieldParseToken +  parseJsonFiled(fieldInfo)              
        }

        return fieldParseToken
    }

    private func parseJsonFiled(fieldInfo: NodeFormat_VarDecl): Tokens {
        //TODO: get type from getType() or init Func()
        let (identifier, name, typeInfo) = getFieldInfo(fieldInfo)

        let tokens: Tokens = match(typeInfo) {
            case "String" =>  quote(
                ret.$identifier = jsonObject.get($name).asString().getOrThrow().getValue()
            )
            case "Int64" => quote(
                try {
                    ret.$identifier = jsonObject.get($name).asInt().getOrThrow().getValue()
                } catch(e: NoneValueException) {
                    throw Exception("Exception caught: " + $name)
                }
            )
            case _ => Tokens()
        }  

        return tokens
    }
}

open class ClassProcessor {
    public func getFieldInfo(fieldInfo: NodeFormat_VarDecl): (Token, String, String) {
        let identifier = fieldInfo.getIdentifier()
        let name = identifier.value
        var typeName: String
        
        try {
            typeName = match(fieldInfo.getType()) {
                case Some(v) where v.isRefType() => v.asRefType().getIdentifier().value
                case Some(v) where v.isPrimitiveType() => v.asPrimitiveType().getPrimitive().value
                case Some(v) => "OTHER TYPE"
                case _ => "NO TYPE"
            }
            //typeName = fieldInfo.getType().getOrThrow().asRefType().getIdentifier().value
        } catch (exp: NoneValueException) {
            //TODO: make new exception type
            throw Exception("Field ${name} must be declared with a specific type instead of using a inferred type")
        }
        
        return (identifier, name, typeName)
    }
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
            fileInfoList.add(decl.asVarDecl())
        }
        
        return true
    }
}
