//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Azar Aliyev on 5/14/24.
//  Copyright © 2024 Azar Aliyev. All rights reserved.
//

import Foundation

struct K {
    static let cellIdentifier = "ReusableCell"
    static let myCellIdentifier = "MyMessageReusableCell"
    static let cellNibName = "MessageCell"
    static let myCellNibName = "MyMessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let replyUserField = "replyUser"
        static let replyMessageField = "replyMessage"
    }
}
