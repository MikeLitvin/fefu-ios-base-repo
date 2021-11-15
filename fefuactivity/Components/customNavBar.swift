//
//  customNavBar.swift
//  fefuactivity
//
//  Created by Mike Litvin on 09.11.2021.
//

import UIKit

class customNavBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activity = UINavigationController(rootViewController: ActivitiesController())
        let profile = UINavigationController(rootViewController: ProfileController())
        
        self.setViewControllers([activity, profile], animated: true)
        
    }
    
}
