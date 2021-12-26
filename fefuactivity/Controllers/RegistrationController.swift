//
//  RegistrationController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 07.10.2021.
//

import UIKit

class RegistrationController: UIViewController {
    
    static private let encoder = JSONEncoder()
    private var genderId = 0
    
    @IBOutlet weak var loginField: registrationTextField!
    @IBOutlet weak var genderField: registrationTextField!
    @IBOutlet weak var passwordField: passwordTextField!
    @IBOutlet weak var confirmPasswordField: passwordTextField!
    @IBOutlet weak var nameField: registrationTextField!
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""
        let passwordConfirm = confirmPasswordField.text ?? ""
        let name = nameField.text ?? ""
        let gender = genderId
                
        if passwordConfirm != password {
            let alert = UIAlertController(title: "Ошибка", message: "Убедитесь, что пароли сопадают", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Продолжить", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
                
        let body = UserRegBody(login: login, password: password, name: name, gender: gender)
                
        do {
            let requestBody = try Authorization.encoder.encode(body)
            let queue = DispatchQueue.global(qos: .utility)
            Authorization.register(requestBody) { user in
                queue.async {
                    UserDefaults.standard.set(user.token, forKey: "token")
                }
                DispatchQueue.main.async {
                    let activitiesView = ActivitiesController(nibName: "ActivitiesController", bundle: nil)
                    self.present(activitiesView, animated: true, completion: nil)
                }
            } onError: { err in
                DispatchQueue.main.async {
                    self.checkApiErrors(errors: err.errors)
                }
            }
        } catch {
            print(error)
        }
    }
    
    let genders = ["Мужчина", "Женщина"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem()
        navigationController?.navigationBar.topItem?.backBarButtonItem = button
        button.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.title = "Регистрация"
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderField.inputView = pickerView
        
    }
}

extension RegistrationController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
     
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderId = row
        genderField.text = genders[row]
        genderField.resignFirstResponder()
    }
    private func checkApiErrors(errors: Dictionary<String, [String]>){
        var alertText = String()
        for (_, values) in errors.reversed() {
            for e in values {
                alertText += e + "\n"
            }
        }
            
        let alert = UIAlertController(title: "Что-то пошло не так", message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Попробовать ещё раз", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
