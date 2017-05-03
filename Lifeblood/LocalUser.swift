//
//  LocalUser.swift
//  Lifeblood
//
//  Created by Bryan Tong on 5/2/17.
//  Copyright © 2017 btong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class LocalUser {
    
    let dbRef = FIRDatabase.database().reference()
    
    /* R E F E R E N C E :
    userChild.child("name").setValue(name)
    userChild.child("age").setValue(age)
    userChild.child("zipcode").setValue(location)
    userChild.child("maxZip").setValue(userMaxLocation)
    userChild.child("minZip").setValue(userMinLocation)
    userChild.child("bloodType").setValue(bloodType)
    userChild.child("purpose").setValue(purpose)
    userChild.child("email").setValue(email) */

    var name: String!
    var age: String!
    var zipcode: Int!
    var maxZip: Int!
    var minZip: Int!
    var bloodType: String!
    var purpose: Bool!
    var email: String!
    var username: String!
    var uid: String!
    
    init() {
        let thisUser = FIRAuth.auth()?.currentUser
        username = thisUser?.displayName
        uid = thisUser?.uid
        let currentUser = dbRef.child((thisUser?.uid)!)
        // more init stuff
        name = currentUser.value(forKeyPath: "name") as! String
        age = currentUser.value(forKeyPath: "age") as! String
        zipcode = currentUser.value(forKeyPath: "zipcode") as! Int
        maxZip = currentUser.value(forKeyPath: "name") as! Int
        minZip = currentUser.value(forKeyPath: "name") as! Int
        bloodType = currentUser.value(forKeyPath: "name") as! String!
        email = thisUser?.email!
    }
    
    func isMatch(bloodToMatch: String) -> Bool {
        if (bloodToMatch == bloodType) { // Base case, identfical match
            return true
        }
        let you = bloodType.characters
        let matchee = bloodToMatch.characters
        if (purpose) { // DONOR CASE
            if ((you.contains("+") && matchee.contains("+")) || you.contains("-")) { // - good for donor universality
                if (you.contains("O")) { // O, Universal donor
                    return true
                } else if (you.contains("A") && (matchee.contains("A"))) {
                    return true
                } else if (you.contains("B") && (matchee.contains("B"))) {
                    return true
                } else {
                    if ((you.contains("A") && matchee.contains("A")) &&
                        (you.contains("B") && matchee.contains("B"))) {
                        return true

                    }
                }
            }
            
        } else { // RECEIVER CASE
            if ((you.contains("-") && matchee.contains("-")) || you.contains("+")) { // + good for receiving
                if ((you.contains("A") && matchee.contains("A")) &&
                    (you.contains("B") && matchee.contains("B"))) { // AB, universal receiver
                    return true
                } else if (you.contains("A") && (matchee.contains("A"))) {
                    return true
                } else if (you.contains("B") && (matchee.contains("B"))) {
                    return true
                } else {
                    if ((you.contains("O") && matchee.contains("O"))) {
                        return true
                    }
                }
            }
            
        }
        return false
    }

}
