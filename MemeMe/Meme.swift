//
//  Meme.swift
//  MemeMe
//
//  Created by Wagner  Filho on 11/08/2018.
//  Copyright © 2018 Artesmix. All rights reserved.
//

import Foundation
import UIKit

struct Meme{
    var textTop: String
    var textBottom:String
    var originalImage: UIImage
    var memedImage: UIImage
    
    static func count() -> Int {
        return getMemeStorage().memes.count
    }
    
    static func getMemeStorage() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
