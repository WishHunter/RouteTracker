//
//  CoordinateEntity.swift
//  RouteTracker
//
//  Created by Denis Molkov on 07.11.2021.
//

import Foundation
import RealmSwift


class CoordinateEntity: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
