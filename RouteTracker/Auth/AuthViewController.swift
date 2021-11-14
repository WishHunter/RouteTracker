//
//  AuthViewController.swift
//  RouteTracker
//
//  Created by Denis Molkov on 10.11.2021.
//

import UIKit
import RealmSwift

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var router: LoginRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchUser(login: String, password: String) -> Bool {
        var isFind = false
        
        do {
            let realm = try Realm()
            let user = realm.objects(UserEntity.self).filter("login = '\(login)' AND password = '\(password)'")
            
            isFind = !user.isEmpty
            
        } catch { print(error) }
        
        return isFind
    }
    
    func showError() {
        let alert = UIAlertController(title: "Error", message: "Wrong login or password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordTextField.text = ""
            self.loginTextField.text = ""
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    @IBAction func registrationAction(_ sender: Any) {
        router.toRegister()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              searchUser(login: login, password: password)
        else {
            showError()
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
}
