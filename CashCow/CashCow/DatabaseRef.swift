//
//  DatabaseReference.swift
//  CashCow
//
//  Created by Bridget Kelly on 2/23/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class DatabaseRef {
    var ref = Database.database().reference()
    var firebaseAuth = Auth.auth()
    
    func getUser() -> [String: Any]? {
        var info: [String: Any]?
        if let user = self.firebaseAuth.currentUser {
            self.ref.child("users/\(user.uid)").getData { (error, snapshot) in
                if let err = error {
                    print("Error getting data \(err)")
                    return nil
                }
                else if snapshot.exists() {
                    print("Got data \(snapshot.value ?? "")")
                    return snapshot.value as? [String: Any]
                }
                else {
                    print("No data available")
                    return self.ref.child("users/\(user.uid)").setValue(["email": user.email])
                }
            }
        }
        
    }
}
