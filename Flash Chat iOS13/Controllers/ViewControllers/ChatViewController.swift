//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func sendPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        logOutUser()
    }
    
    //MARK: - Helper Functions
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func setupViews() {
        hidesBackButton()
        setupTitle()
    }
    
    func setupTitle() {
        title = K.appName
    }
    
    func hidesBackButton() {
        navigationItem.hidesBackButton = true
    }
}//END OF CLASS
