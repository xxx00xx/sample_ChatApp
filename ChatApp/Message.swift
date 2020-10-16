//
//  Message.swift
//  ChatApp
//
//  Created by 古田翔太郎 on 2020/10/17.
//  Copyright © 2020 古田翔太郎. All rights reserved.
//

import Foundation
import RealmSwift

class Message: Object {
    @objc dynamic var messageTitle: String = ""
    //個別のチャットデータが入るListの定義
    let chatData = List<ChatData>()
}

class ChatData: Object {
    @objc dynamic var content: String = ""          //チャット内容
    @objc dynamic var time: String = ""             //チャット時刻
    @objc dynamic var isQuestioner: Bool = false    //質問者か回答者かの判別
}
