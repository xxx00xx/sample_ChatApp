//
//  Chat.swift
//  ChatApp
//
//  Created by 古田翔太郎 on 2020/09/28.
//  Copyright © 2020 古田翔太郎. All rights reserved.
//

import Foundation
import RealmSwift

class Chat: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    //@objc dynamic var deadline: Date = Date()
    @objc dynamic var time: String = ""   //deadline: Date = Date()

    /*
    // IDをプライマリキーとして利用する場合に使う
    override class func primaryKey() -> String? {
        return "id"
    }
    */
}


