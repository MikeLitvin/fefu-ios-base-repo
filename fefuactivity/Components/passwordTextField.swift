//
//  passwordTextField.swift
//  fefuactivity
//
//  Created by Mike Litvin on 19.10.2021.
//

import Foundation
import UIKit

class passwordTextField: registrationTextField {
    
    let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            enablePasswordToggle()
        }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            enablePasswordToggle()
        }
    

    func enablePasswordToggle() {
        
        self.isSecureTextEntry = true
        
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.setImage(UIImage(named: "closedEye"), for: .selected)
        rightView = button
        rightViewMode = .always
        button.alpha = 1
        textContentType = .oneTimeCode
        
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
    }
    
    @objc func togglePasswordView(_ sender: Any){
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }

}
