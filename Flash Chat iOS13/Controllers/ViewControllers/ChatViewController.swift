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
    
    //MARK: - Properties
    var messages: [Message] = []
    let db = Firestore.firestore()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func sendPressed(_ sender: UIButton) {
        sendMessage()
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        logOutUser()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        hidesBackButton()
        setupTitle()
        setupCustomCell()
        loadMessages()
    }
    
    func setupTitle() {
        title = K.appName
    }
    
    func hidesBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    func setupCustomCell() {
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func sendMessage() {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField : Date().timeIntervalSince1970
            ]) { (error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    print("Successfully saved data")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.messages = []
                
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if  let messageSender = data[K.FStore.senderField] as? String,
                                let messageBody = data[K.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
            }
    }
}//END OF CLASS

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
        
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
}//END OF EXTENSION
