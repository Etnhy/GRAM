//
//  User.swift
//
//
//  Created by evhn on 20.02.2024.
//

import Fluent
import Vapor

struct AuthUserDTO: Content {
    let login: String
    var password: String
}

final class User: Model, Content {
    
    static var schema: String = "user"
    
    @ID var id: UUID?
    @Field(key: "login") var login: String
    @Field(key: "email") var email: String
    
    @Field(key: "password") var password: String
    
    @Field(key: "name") var name: String

    @Field(key: "age") var age: Int
    @Field(key: "hobby") var hobby: String
    
    
    final class Public: Content {
        var login: String
        var name: String
        var age: Int
        var hobby: String
        
        init(login: String, name: String, age: Int, hobby: String) {
            self.login = login
            self.name = name
            self.age = age
            self.hobby = hobby
        }
        
    }
}


extension User {
    public func convertToPublic() -> User.Public {
        let user = User.Public(login: self.login, name: self.name, age: self.age, hobby: self.hobby)
        return user
    }
}
