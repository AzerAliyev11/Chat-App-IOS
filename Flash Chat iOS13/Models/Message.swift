//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Azar Aliyev on 5/14/24.
//  Copyright © 2024 Azar Aliyev. All rights reserved.
//

import Foundation

struct Message {
    let sender: String
    let body: String
    let repliedUser: String?
    let repliedMessage: String?
}
