//
//  CollectionViewCell.swift
//  MemeMe
//
//  Created by Wagner  Filho on 17/08/2018.
//  Copyright © 2018 Artesmix. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImg: UIImageView!
    
    func updateCell(_ meme: Meme) {

        memeImg.image = meme.memedImage
    }
}
