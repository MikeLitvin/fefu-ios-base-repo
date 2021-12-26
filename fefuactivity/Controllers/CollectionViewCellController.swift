//
//  CollectionViewCellController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 21.12.2021.
//

import UIKit

struct collectionCell{
    let name: String
    let img: UIImage
    let type: String
}

class CollectionViewCellController: UICollectionViewCell{
    
    @IBOutlet weak var cellNamelabel: UILabel!
    @IBOutlet weak var customCell: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    
    var cellType: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        customCell.layer.borderWidth = 1
        customCell.layer.cornerRadius = 10
        customCell.layer.masksToBounds = true
    }

    func setCellStats(_ model: collectionCell){
        cellNamelabel.text = model.name
        cellImage.image = model.img
        cellType = model.type
    }
}
