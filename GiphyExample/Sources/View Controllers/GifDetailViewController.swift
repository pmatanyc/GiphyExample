//
//  GifDetailViewController.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/9/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import UIKit

class GifDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    weak var gif: UIImage? = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let gif = gif {
            self.imageView.frame.size = gif.size
            self.imageView.image = gif
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
