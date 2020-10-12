//
//  QuestionerViewController.swift
//  ChatApp
//
//  Created by 古田翔太郎 on 2020/09/28.
//  Copyright © 2020 古田翔太郎. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionerViewController: UIViewController {

    var text = ""
    var chat: Chat?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // タイトル文字列の設定
        self.navigationItem.title = text//"先頭ページ"
        /*
        //トップに戻るボタンを作成
        let leftButton = UIBarButtonItem(
        title:  "戻る",
        style:  .plain,
        target: nil,
        action: nil)
        self.navigationItem.backBarButtonItem = leftButton
         */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
