//
//  Alerts.swift
//  Flash Chat iOS13
//
//  Created by Deven Day on 3/22/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

extension ChatViewController {
    
    func logOutAlert() {
        let actionSheet = UIAlertController(title: "Sign Out?",
                                            message: "Are you sure?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "YES", style: .destructive, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
