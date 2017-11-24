//
//  LoginViewController.swift
//  CrownDealerRating
//
//  Created by Campbell Brobbel on 12/11/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func successfulLogin()
}
class LoginViewController: UIViewController {
    
    let loginURL = "http://18.221.45.138/login.php"
    let employeeURL = "http://18.221.45.138/employees.php"
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var loginDelegate: LoginDelegate?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func login(_ sender: Any) {
        if let username : String = self.usernameTextField.text {
            if let password : String = self.passwordTextField.text {
                
                var loginSuccess : Bool = false
                let sem = DispatchSemaphore(value: 0)
                NetworkManager.shared.auth(url: loginURL, username: username, password: password, completion: {success, error in
                    
                    if error != nil {
                        self.networkAlert(message: error!.localizedDescription)
                    }
                    else {
                        loginSuccess = success
                        if(success) {
                            print("Login is successful")
                            sem.signal()
                        }
                        else {
                            DispatchQueue.main.async {
                                self.presentAlert(alertMessage: "Incorrect Username or Password")
                            }
                            print("Incorrect Username or Password")
                            sem.signal()
                        }
                    }
                    
                })
                sem.wait()
                print("Login Success \(loginSuccess)")
                if loginSuccess {
                    let queryURLString = "\(employeeURL)?empID=\(username)"
                    
                    NetworkManager.shared.getData(from: queryURLString, completion: {data, error in
                        print("Inside Network")
                        do {
                            let user = try JSONDecoder().decode(AssessmentLadder.Employee.self, from: data!)
                            self.delegate.user = user
                            print("After Successful Login1")
                            sem.signal()
                        }
                        catch {
                            print("After Successful Login 2")
                        }
                    })
                    sem.wait()
                    print("After Successful Login")
                    print(self.delegate.user)
                    self.loginDelegate?.successfulLogin()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                self.presentAlert(alertMessage: "Please Enter Password")
                print("Please Enter Password")
            }
        }
        else {
            self.presentAlert(alertMessage: "Please Enter Username")
            print("Please Enter Username")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoginButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentAlert(alertMessage: String) {
        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    private func setupLoginButton() {
        self.loginButton.layer.borderColor = UIColor.white.cgColor
        self.loginButton.layer.borderWidth = 2
        self.loginButton.layer.cornerRadius = 5
    }
    
    private func networkAlert(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Wifi Settings", style: .default, handler: {(action) in
            
            alert.dismiss(animated: true, completion: nil)
            UIApplication.shared.open(URL(string: "App-Prefs:root=WIFI")!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) in
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
