//
//  AuthViewController.swift
//  RouteTracker
//
//  Created by Denis Molkov on 10.11.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
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
        loginButton.isEnabled = false
        configureLoginBindings()
    }
    
    @objc func showPrivateMode(_ notification: Notification) {
        loginTextField.layer.opacity = 0
        passwordTextField.layer.opacity = 0
    }
    
    @objc func hidePrivateMode(_ notification: Notification) {
        loginTextField.layer.opacity = 1
        passwordTextField.layer.opacity = 1
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
    
    //MARK: - Actions
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
    
    //MARK: - Bindings
    func configureLoginBindings() {
        Observable
            .combineLatest(loginTextField.rx.text, passwordTextField.rx.text)
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak loginButton] inputFilled in
                loginButton?.isEnabled = inputFilled
            }
    }
}
