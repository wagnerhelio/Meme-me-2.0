//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Wagner  Filho on 17/08/2018.
//  Copyright © 2018 Artesmix. All rights reserved.
//

import UIKit

class  DetailMemeViewController: UIViewController {

    @IBOutlet var memedImage: UIImageView!

    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImage.image = meme.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
