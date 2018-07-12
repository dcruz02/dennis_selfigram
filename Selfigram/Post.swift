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
    
    let image: UIImage
    let user: User
    let comment: String
    
    init(imageInp: UIImage, userInp: User, commentInp: String) {
        image = imageInp
        user = userInp
        comment = commentInp
    }
    
}
