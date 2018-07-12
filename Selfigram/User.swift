//
//  User.swift
//  Selfigram
//
//  Created by Dennis Cruz on 2018-07-11.
//  Copyright © 2018 Dennis Cruz. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    let username: String
    let profileImage: UIImage
    
    init(usernameInp: String, profileImageInp: UIImage) {
        username = usernameInp
        profileImage = profileImageInp
    }
}

