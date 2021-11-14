//
//  BaseRouter.swift
//  RouteTracker
//
//  Created by Denis Molkov on 14.11.2021.
//

import UIKit

class BaseRouter: NSObject {
    @IBOutlet weak var controller: UIViewController!
    
    func show(_ controller: UIViewController) {
        self.controller.show(controller, sender: nil)
    }
    
    func present(_ controller: UIViewController) {
        self.controller.present(controller, animated: true)
    }
    
    func setAsRoot(_ controller: UIViewController) {
        UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?
            .rootViewController = controller
//        UIApplication.shared.keyWindow?.rootViewController = controller
    }
    
}
