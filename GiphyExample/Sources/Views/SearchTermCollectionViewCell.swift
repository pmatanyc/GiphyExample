//
//  SearchTermCollectionViewCell.swift
//  GiphyExample
//
//  Created by Paola Mata on 9/9/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import UIKit

class SearchTermCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel.text =  nil
    }
}
