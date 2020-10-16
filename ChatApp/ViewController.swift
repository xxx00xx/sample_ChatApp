//
//  ViewController.swift
//  ChatApp
//
//  Created by 古田翔太郎 on 2020/09/28.
//  Copyright © 2020 古田翔太郎. All rights reserved.
//
import UIKit
import RealmSwift

class ViewController: UIViewController {

    // didSetにまとめて実行
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    var chatArray: [Chat] = []
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // viewDidAppearでリロード
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        chatArray = realm.objects(Chat.self).map { $0 }
        tableView.reloadData()
    }
    
    // identifierの設定
    let editSegueIdentifier = "toEdit"
    let cellIdentifier = "cell"
    
     var message: Message?
    
    //sugueを準備するときに呼ばれるメゾッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondView" {
            let viewController = segue.destination as! ChatViewController
            viewController.chat = sender as? Chat
            viewController.message = self.message
        }
    }

    @IBAction func addButton(){
        /*------以下，新規チャットルーム作成用のアラート機能------*/
        var alertTextField: UITextField?
        var chat: Chat?
        let realm = try! Realm()
        
        let alert: UIAlertController = UIAlertController(
            title:"新規チャット作成",
            message:"新しいチャット名を記入してください．",
            preferredStyle: UIAlertController.Style.alert)
        //保存ボタン機能
        let okAction: UIAlertAction = UIAlertAction(
            title: "保存",
            style: UIAlertAction.Style.default,
            handler:{(action:UIAlertAction!) -> Void in
                /*
                //IDをプライマリキーとして利用する場合
                func lastId() -> Int {
                    let chats = realm.objects(Chat.self)
                    if let lastChat = chats.last {
                        return lastChat.id + 1
                    } else {
                        return 0
                    }
                }
                */
                
                //TextFieldの中身が""だった場合
                if alertTextField?.text == ""{
                    let alert: UIAlertController = UIAlertController(
                        title: "警告",
                        message: "チャット名を記入してください",
                        preferredStyle:  UIAlertController.Style.alert)
                    // キャンセルボタン
                    let cancelAction: UIAlertAction = UIAlertAction(
                        title: "OK",
                        style: UIAlertAction.Style.cancel,
                        handler:{(action:UIAlertAction!) -> Void in
                            self.addButton()
                    })
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                //TextFieldの中身がきちんと入っていた場合
                } else {
                    let updateChat: Chat
                    if let chat = chat {
                        updateChat = chat
                    } else {
                        updateChat = Chat()
                        //updateChat.id = lastId()
                    }
                    
                    try! realm.write {
                        //saveを押した時，入力されていたテキストをupdateに保存
                        if let text = alertTextField?.text {
                            updateChat.title = text
                            let dictionary: [String: Any] =
                            ["messageTitle": text,
                             "chatData":[]  //初期化
                            ]
                            let message = Message(value: dictionary)
                            realm.add(message)
                            print(message)
                        }
                        
                        //saveを押した時の(日本の)時刻をupdateに保存
                        let dt = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
                        updateChat.time = dateFormatter.string(from: dt)
                        realm.add(updateChat)
                        self.tableView.reloadData()
                    }
                    //ChatQuestionViewController画面へ遷移
                    self.performSegue(withIdentifier: "toSecondView", sender: true)
                }
        })
        //キャンセルボタン機能
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル",
            style: UIAlertAction.Style.cancel,
            handler:{(action:UIAlertAction!) -> Void in
        })
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatTableViewCell

        cell.titleLabel.text = chatArray[indexPath.row].title
        cell.dateLabel.text = chatArray[indexPath.row].time

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toSecondView", sender: chatArray[indexPath.row])
        //テーブル内の行をタップして、次の画面に遷移する???
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //任意行のcellをDelete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(chatArray[indexPath.row])
            }
            chatArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
