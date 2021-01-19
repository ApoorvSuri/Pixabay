//
//  PhotoCollectionCell.swift
//  Pixabay
//
//  Created by Apoorv on 18/05/2019.
//  Copyright © 2019 ApoorvSuri. All rights reserved.
//

import UIKit

struct PhotoCollectionCellViewModel {
    var image: UIImage?
}

class PhotoCollectionCell: UICollectionViewCell {
    static let cellID = "PhotoCollectionCell"
    @IBOutlet weak var imgView: UIImageView!
    
    func setData(_ viewModel: PhotoCollectionCellViewModel?) {
        imgView.image = viewModel?.image
    }
}
