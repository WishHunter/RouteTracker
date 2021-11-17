//
//  RegisterViewController.swift
//  RouteTracker
//
//  Created by Denis Molkov on 10.11.2021.
//

import UIKit
import RealmSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var router: LoginRouter!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(showPrivateMode(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidePrivateMode(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    //MARK: - Functions
    func initController() {
        loginTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
    }
    
    @objc func showPrivateMode(_ notification: Notification) {
        loginTextField.layer.opacity = 0
        passwordTextField.layer.opacity = 0
    }
    
    @objc func hidePrivateMode(_ notification: Notification) {
        loginTextField.layer.opacity = 1
        passwordTextField.layer.opacity = 1
    }
    
    func findSimilarUser(login: String) -> Bool {
        var isFind = false
        
        do {
            let realm = try Realm()
            let user = realm.objects(UserEntity.self).filter("login contains[cd] %@", login)
            
            isFind = user.isEmpty
            
        } catch { print(error) }
        
        return isFind
    }
    
    func showError(similarUser: Bool) {
        let message = similarUser ? "User with this login already exists" : "Something is wrong, try again"
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordTextField.text = ""
            self.loginTextField.text = ""
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func editNewUser(login: String, password: String) -> Bool {
        var isEdit = false
        
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            realm.beginWrite()
            let user = UserEntity()
            user.login = login
            user.password = password
            realm.add(user, update: .modified)
            try realm.commitWrite()
            
            isEdit = true
        } catch { print(error) }
        
        return isEdit
    }
    
    //MARK: - Actions
    @IBAction func registrationAction(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else {
            showError(similarUser: false)
            return
        }
        
        guard findSimilarUser(login: login) else {
            showError(similarUser: true)
            return
        }
        
        guard editNewUser(login: login, password: password) else {
            showError(similarUser: false)
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }
}
