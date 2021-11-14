//
//  MainRouter.swift
//  RouteTracker
//
//  Created by Denis Molkov on 14.11.2021.
//

import UIKit

final class MainRouter: BaseRouter {
    func toAuth() {
        let controller = UIStoryboard(name: "AuthStoryboard", bundle: nil)
            .instantiateViewController(AuthViewController.self)
        
        setAsRoot(controller)
    }
}
