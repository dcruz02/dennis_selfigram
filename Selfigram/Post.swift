//
//  Post.swift
//  Selfigram
//
//  Created by Dennis Cruz on 2018-07-11.
//  Copyright © 2018 Dennis Cruz. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    let imageURL: URL
    let user: User
    let comment: String
    
    init(imageInp: URL, userInp: User, commentInp: String) {
        imageURL = imageInp
        user = userInp
        comment = commentInp
    }
    
}
