//
//  LoginController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 15.10.2021.
//

import UIKit

class LoginController: UIViewController {
    static private let encoder = JSONEncoder()
    
    @IBOutlet weak var passwordField: passwordTextField!
    @IBOutlet weak var loginField: registrationTextField!
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""

        let body = UserLoginBody(login: login, password: password)

        do {
        let requestBody = try LoginController.encoder.encode(body)
        let queue = DispatchQueue.global(qos: .utility)
        Authorization.login(requestBody) { user in
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

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem()
        navigationController?.navigationBar.topItem?.backBarButtonItem = button
        button.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationItem.title = "Вход"
    }
    
    private func checkApiErrors(errors: Dictionary<String, [String]>) {
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
