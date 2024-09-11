package CJson.serialization.adaptor

import std.ast.*
import std.{collection.Map, collection.HashMap}

/*
* Interface for json adaptor
*/
public interface JsonAdaptor {
    
    /*
    * Sets the type of the adaptor
    * @param thisType the type token for the identifier, the token is used
    * for later operations when doing serializationd and deserialization
    */
    func setType(thisType: TypeNode): Unit

    /*
    * Makes token representation for deserializing the given json to pass it on to the receiver
    * @param valueReceiver_TK the receiver for the deserialized value
    * @param jsonVar_Tk the var that holds the source json value
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @return Tokens the token representation 
    */
    func fromJsonValue(valueReceiver_TK: Tokens, jsonVar_Tk: Tokens, varIdentifierName: String): Tokens
    
    /*
    / Composes a func for serialization of the valueVar, this func can be invoked later with funcName_Tk()
    / for example:
    /   return quote(
    /       func $funcName_Tk() {
    /           return JsonString($valueVar_Tk)
    /       }
    /   )
    */
    /*
    * Makes token representation for serializing the given value to json
    * @param valueVar_Tk the source of the value
    * @param funcName_Tk the predefined func name for serialization, to be used later as refence for func call
    * @param varIdentifierName the identifier name of the receiver, using for internal namespaing
    * @return Tokens the token representation 
    */
    func toJsonValueFunc(valueVar_Tk: Tokens, funcName_Tk: Tokens, varIdentifierName: String): Tokens
}