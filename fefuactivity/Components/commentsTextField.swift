//
//  commentsTextField.swift
//  fefuactivity
//
//  Created by Mike Litvin on 04.11.2021.
//

import UIKit

class commentsTextField: UITextField {
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            fieldInit()
        }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        fieldInit()
    }
    
    private func fieldInit(){
        layer.cornerRadius = 8
        layer.borderWidth = 0.5
        layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        layer.backgroundColor = CGColor(red: 120, green: 120, blue: 128, alpha: 0.16)
        }
}
