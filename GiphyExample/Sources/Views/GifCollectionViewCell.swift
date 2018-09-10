//
//  GifCollectionViewCell.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/8/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }    
}
