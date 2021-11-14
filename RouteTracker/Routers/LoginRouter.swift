//
//  LoginRouter.swift
//  RouteTracker
//
//  Created by Denis Molkov on 14.11.2021.
//

import UIKit

final class LoginRouter: BaseRouter {
    func toMain() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        setAsRoot(UINavigationController(rootViewController: controller))
    }
    
    func toRegister() {
        let controller = UIStoryboard(name: "AuthStoryboard", bundle: nil)
            .instantiateViewController(RegisterViewController.self)
                
        present(controller)
    }
}
