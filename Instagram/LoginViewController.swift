//
//  LoginViewController.swift
//  Instagram
//
//  Created by sora on 2019/07/19.
//  Copyright © 2019 sora. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

    

    @IBOutlet weak var mailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { user, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                // HUDを消す
                SVProgressHUD.dismiss()
                
                // 画面を閉じてViewControllerに戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            
            // HUDで処理中を表示
            SVProgressHUD.show()
            
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        // HUDを消す
                        SVProgressHUD.dismiss()
                        
                        // 画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        displayNameTextField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        displayNameTextField.resignFirstResponder()
    }

}
