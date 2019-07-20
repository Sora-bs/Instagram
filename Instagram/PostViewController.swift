//
//  PostViewController.swift
//  Instagram
//
//  Created by sora on 2019/07/19.
//  Copyright © 2019 sora. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {

    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 受け取った画像をImageViewに設定する
        imageView.image = image
    }
    
    @IBAction func handlePostButton(_ sender: Any) {
        
        
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        
        
    }
    
}
