//
//  userValue.swift
//  FirebaseAuthentication
//
//  Created by Neha Penkalkar on 04/05/21.
//

import Foundation

class userValue: NSObject{
    var id: String
    var number: String
    var firstName: String
    var lastName: String
    var password: String
    var email: String
    
    init(id: String,firstName: String, lastName: String,password: String,email: String,number: String){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.number = number
    }
}
