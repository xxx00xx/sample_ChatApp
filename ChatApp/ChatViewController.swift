//
//  QuestionerViewController.swift
//  ChatApp
//
//  Created by 古田翔太郎 on 2020/09/28.
//  Copyright © 2020 古田翔太郎. All rights reserved.
//

import UIKit
import RealmSwift
import MessageKit
import InputBarAccessoryView

/*
class QuestionerViewController: UIViewController {

    var text = ""
    var chat: Chat?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // タイトル文字列の設定
        self.navigationItem.title = text
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
}
*/

class ChatViewController: MessagesViewController {
    
    var chat: Chat?
    var chatArray: [Chat] = []
    var messageList: [MockMessage] = []
    var indexPath: Int!
    //var text = chatArray[indexPath].title
    var message: Results<Message>!
    
    let realm = try! Realm()

    let dateFormatter:DateFormatter = DateFormatter()              //日時のフォーマットを管理するもの
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("App open")
        
        // タイトル文字列の設定
        //self.navigationItem.title = text
        
      DispatchQueue.main.async {
            // messageListにメッセージの配列をいれて
            self.messageList = self.getMessages()
            // messagesCollectionViewをリロードして
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToBottom()
        }

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self

        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
      
        // メッセージ入力時に一番下までスクロール
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        //DateFormatter()で日付と時刻と地域を指定(今回は日本時間を指定)
        dateFormatter.dateStyle = .medium //日付の表示スタイルを決定
        dateFormatter.timeStyle = .short  //時刻の表示スタイルを決定
        dateFormatter.locale = Locale(identifier: "ja_JP")//地域を決定
    }

    // sample message
    func getMessages() -> [MockMessage] {
        return [
            //createMessage(text: "あああ？")
        ]
    }

    func createMessage(text: String) -> MockMessage {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                           .foregroundColor: UIColor.black])
        return MockMessage(attributedText: attributedText, sender: otherSender(), messageId: UUID().uuidString, date: Date())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(id: "xxx", displayName: "Question")
    }

    func otherSender() -> SenderType {
        return Sender(id: "yyy", displayName: "Answer")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    // 3メッセージ毎に時刻を表示　→ 時刻が変わる際に，表示したい．
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                             NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            )
        }
        return nil
    }

    // メッセージの上に名前を表示
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    // メッセージの下に日付を表示
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// メッセージのdelegate
extension ChatViewController: MessagesDisplayDelegate {

    // メッセージの色を変更（デフォルトは自分：白、相手：黒）
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }

    // メッセージの背景色を変更している（デフォルトは自分：緑、相手：グレー）
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // message.sender.displayNameとかで送信者の名前を取得できるので
        // そこからイニシャルを生成するとよい
        let avatarQ = Avatar(initials: "Q")
        let avatarA = Avatar(initials: "A")
        avatarView.set(avatar: avatarQ)
        /*
        if message[indexPath.row].senderId == currentSender {
            avatarView.set(avatar: avatarQ)
        }
        */
    }
}


// 各ラベルの高さを設定（デフォルト0なので必須）
extension ChatViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension ChatViewController: MessageCellDelegate {
    // メッセージをタップした時の挙動→削除とか編集で後々使う
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    // メッセージ送信ボタンをタップした時の挙動
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
        for _ in inputBar.inputTextView.components {
        
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                                          .foregroundColor: UIColor.white])
        let message = MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
        messageList.append(message)
        messagesCollectionView.insertSections([messageList.count - 1])
        }
        //messageモデルをrealmに保存する．
        //インスタンスの取得
        
        let realm = try! Realm()
        
        let chat = ChatData()
        
        //書き込み処理
        try! realm.write {
            //chat.content = 
            realm.add(message)
            print(message)
        }
    
        //inputBarの中のテキストを表示して
        inputBar.inputTextView.text = ""
        
        //一番下までスクロールしている
        messagesCollectionView.scrollToBottom()
     
        print("messageList when sendButton pressed:\(messageList)")
    }
}
