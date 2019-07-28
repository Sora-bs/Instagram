//
//  CommentViewController.swift
//  Instagram
//
//  Created by sora on 2019/07/25.
//  Copyright © 2019 sora. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var commentArray: [CommentData] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        commentTextField.delegate = self
        
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentTextField.resignFirstResponder()
    }
    
    
    @IBAction func commentButton(_ sender: Any) {
        view.endEditing(true)
        
        let name = Auth.auth().currentUser?.displayName
         //辞書を作成してFirebaseに保存する
        let commentRef = Database.database().reference().child(Const.CommentPath)
        let commentDic = ["comments": commentTextField.text!, "name": name!]
        commentRef.childByAutoId().setValue(commentDic)

        print("DEBUG_PRINT:\(name!)がコメントしました。")
        print("DEBUG_PRINT:\(commentTextField.text!)が送信されました。")

        commentTextField.text = ""
        
         //HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        
        
        self.tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNotificationForTextField()

    }
    
    internal func setUpNotificationForTextField() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo //この中にキーボードの情報がある
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.commentTextField?.frame.origin.y)!
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            
        }
    }
    
    @objc private func handleKeyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    
}
