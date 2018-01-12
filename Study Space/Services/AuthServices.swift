//
//  AuthServices.swift
//  Study Space
//
//  Created by Gray Zhen on 1/7/18.
//  Copyright © 2018 GrayStudio. All rights reserved.
//

import Foundation
import Firebase

class AuthServices {
    
    static let instance = AuthServices()
    
    func registerUser(withEmail email: String, andPassword password: String, whenCompleted complete: @escaping (_ completed: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let user = user, let userEmail = user.email {
                let userData: Dictionary<String, Any> = ["provider" : user.providerID, "email": userEmail]
                DataServices.instance.createDatabaseUser(withUID: user.uid, andUserInfo: userData)
                complete(true, nil)
            }else {
                complete(false, error)
                return
            }
            
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, whenCompleted complete: @escaping (_ completed: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                complete(false, error)
                return
            }
            
            complete(true, nil)
            
        }
    }
    
    func logoutUser(whenCompleted complete: @escaping (_ completed: Bool, _ error: Error?) -> ()) {
        if Auth.auth().currentUser != nil {
            
            do {
                try Auth.auth().signOut()
                complete(true, nil)
            }catch let error as NSError {
                complete(false, error)
            }
            
        }
    }
    
    func forgotPasswordReset(withEmail email: String, whenCompleted complete: @escaping (_ completed: Bool, _ error: Error?) -> ()){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error == nil {
                complete(true, nil)
            }else {
                complete(false, error)
            }
            
        }
        
    }
    
}
