import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButtonTap: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        let activities = ActivitiesController(nibName: "ActivitiesController", bundle: nil)
//        present(activities, animated: true, completion: nil)
    }
    
    @IBAction func regButtonTap(_ sender: Any) {
        let regView = RegistrationController(nibName:"RegistrationController", bundle: nil)
        
        navigationController?.pushViewController(regView, animated: true)
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        let logView = ActivitiesController(nibName: "ActivitiesController", bundle: nil)
        navigationController?.pushViewController(logView, animated: true)
    }
    
}
