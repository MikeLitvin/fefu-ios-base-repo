//
//  ActivityDetailsController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 04.11.2021.
//

import UIKit

class ActivityDetailsController: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startFinishLabel: UILabel!
    @IBOutlet weak var descriptionSrcLabel: UIImageView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var timeAgoSecondLabel: UILabel!
    
    var activity: ActivityModel? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        distanceLabel.text = activity?.distance
        timeAgoLabel.text = activity?.deltaTime
        durationLabel.text = activity?.duration
        startFinishLabel.text = "Старт \(activity?.started ?? "null") · Финиш \( activity?.finished ?? "null")"
        descriptionSrcLabel.image = activity?.descriptionSrc
        descriptionTextLabel.text = activity?.descriptionName
        timeAgoSecondLabel.text = activity?.deltaTime
        
        self.title = activity?.descriptionName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
        }
}
