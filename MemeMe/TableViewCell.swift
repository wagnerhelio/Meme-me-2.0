//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Wagner  Filho on 17/08/2018.
//  Copyright © 2018 Artesmix. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var topText: UILabel!
    @IBOutlet var bottomText: UILabel!
    
    @IBOutlet var imgMeme: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCell(_ meme: Meme) {
        
        //update cell's view
        imgMeme.image = meme.memedImage
        topText.text = meme.textTop as String?
        bottomText.text = meme.textBottom as String?
    }

}
