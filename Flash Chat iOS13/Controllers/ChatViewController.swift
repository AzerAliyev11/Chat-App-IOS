//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var replyLabelsView: UIView!
    @IBOutlet weak var replyCloseView: UIView!
    
    @IBAction func closeReplyButton(_ sender: UIButton) {
        hideReplyArea()
    }
    
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyLabelsView.roundLeftCorner(radius: 20)
        replyCloseView.roundRightCorner(radius: 20)
        
        replyViewHeight.constant = 0
        replyView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.hidesBackButton = true
        title = "⚡️FlashChat"
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.register(UINib(nibName: K.myCellNibName, bundle: nil), forCellReuseIdentifier: K.myCellIdentifier)
        
        loadMessages()
    }
    
    func hideReplyArea() {
        replyViewHeight.constant = 0
        replyView.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showReplyArea() {
        replyViewHeight.constant = 60
        replyView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func loadMessages()
    {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { querySnapshot, error in
            if let _ = error {
                print("Error while loading messages!")
            } else {
                //self.messages = []
                if let documents = querySnapshot?.documents {
                    var i = 1
                    for doc in documents {
                        if let sender = doc.data()[K.FStore.senderField] as? String, let body = doc.data()[K.FStore.bodyField] as? String {
                            let rU = doc.data()[K.FStore.replyUserField] as? String
                            let rM = doc.data()[K.FStore.replyMessageField] as? String
                            let message = Message(sender: sender, body: body, repliedUser: rU, repliedMessage: rM)
                            if(i > self.messages.count) {
                                self.messages.append(message)
                                
                                let newMessageIndex = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.beginUpdates()
                                self.tableView.insertRows(at: [newMessageIndex], with: .none)
                                self.tableView.endUpdates()
                            }
                            i += 1
                        }
                    }
                    
                    if self.messages.count > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let userEmail = Auth.auth().currentUser?.email {
            messageTextfield.text = ""
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: userEmail,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970,
                K.FStore.replyMessageField: messageLabel.text ?? NSNull(),
                K.FStore.replyUserField: replyLabel.text ?? NSNull()
            ]) { error in
                if let _ = error {
                    print("Error while sending data to database")
                } else {
                    print("Data successfully sent!")
                }
            }
        }
    }
    

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.myCellIdentifier, for: indexPath) as! MyMessageCell
            cell.messageLabel.text = messages[indexPath.row].body
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        
        if let rU =  messages[indexPath.row].repliedUser, let rM = messages[indexPath.row].repliedMessage {
            if rU.isEmpty {
                cell.withoutRepylSetup()
            }
            else {
                cell.withReplySetup(repliedUser: rU, repliedMessage: rM)
            }
        }
        else {
            cell.withoutRepylSetup()
        }
        
        if let firstCharacter = messages[indexPath.row].sender.first {
            cell.userNameLabel.text = String(firstCharacter.uppercased())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let replyAction = UIContextualAction(style: .normal, title: "Reply") { _, _, completionHandler in
            tableView.setEditing(false, animated: true)
            self.replyLabel.text = "Reply to \(self.messages[indexPath.row].sender)"
            self.messageLabel.text = self.messages[indexPath.row].body
            self.showReplyArea()
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .none, animated: true)
        }
        replyAction.backgroundColor = UIColor(named: K.BrandColors.blue)
        let swipeConfg = UISwipeActionsConfiguration(actions: [replyAction])
        swipeConfg.performsFirstActionWithFullSwipe = false
        return swipeConfg
    }
    
}

extension ChatViewController: UITableViewDelegate {
    
}

extension UIView {
    func roundLeftCorner(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topLeft],
                                cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundRightCorner(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundBottomLeftCorner(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundBottomRightCorner(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
