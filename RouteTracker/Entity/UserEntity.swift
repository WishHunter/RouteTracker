//
//  UserEntity.swift
//  RouteTracker
//
//  Created by Denis Molkov on 14.11.2021.
//

import Foundation
import RealmSwift

class UserEntity: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
