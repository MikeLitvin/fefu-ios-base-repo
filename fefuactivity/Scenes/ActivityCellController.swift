//
//  ActivityCellController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 31.10.2021.
//

import UIKit

struct ActivityDescription{
    let name: String
    let src: UIImage
}

struct ActivityModel {
    let distance: String
    let duration: String
    let description: ActivityDescription
    let deltaTime: String
    let started: String
    let finished: String
}

class ActivityCellController: UITableViewCell {
    
    @IBOutlet weak var customCellView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customCellView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)  
    }
    
    func setCellStats(_ model: ActivityModel){
        distanceLabel.text = model.distance
        durationLabel.text = model.duration
        descriptionImage.image = model.description.src
        descriptionLabel.text = model.description.name
        finishedLabel.text = model.deltaTime
    }
    
}
