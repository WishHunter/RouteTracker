//
//  MapViewController.swift
//  RouteTracker
//
//  Created by Denis Molkov on 03.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
    var locationManager: CLLocationManager?
    var route: GMSPolyline? {
        didSet {
            route?.strokeColor = .yellow
            route?.strokeWidth = 12
        }
    }
    var routePath: GMSMutablePath?
    var isActiveTrack = false
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerButton: UIButton!
    @IBOutlet weak var router: MainRouter!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureMapStyle()
        configureLocationManager()
    }
    
    //MARK: - Functions
    
    func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        
        mapView.camera = camera
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func addMarker(coordinate: CLLocationCoordinate2D) {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        circleView.layer.cornerRadius = 5
        circleView.backgroundColor = .green
        
        let marker = GMSMarker(position: coordinate)
        marker.iconView = circleView
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.map = mapView
    }
    
    func writeTrack() {
        do {
            var coordinates: [CoordinateEntity] = []
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            
            guard let routePath = routePath else { return }
            
            for index in 0..<routePath.count() {
                let dotPath = routePath.coordinate(at: index)
                let coordinate = CoordinateEntity()
                coordinate.latitude = dotPath.latitude
                coordinate.longitude = dotPath.longitude
                coordinates.append(coordinate)
            }
            
            try realm.write {
                realm.deleteAll()
                realm.add(coordinates)
            }
            
        } catch { print(error) }
    }
    
    func createTrack() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        isActiveTrack = true
    }
    
    func showConfirmation() {
        let alert = UIAlertController(title: "You need to stop the current track",
                                      message: "Do you want to reset the current tracking?",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes",
                               style: .default) { [weak self] action in
            self?.locationManager?.stopUpdatingLocation()
            self?.isActiveTrack = false
            self?.showLastTrack()
        }
        let cancel = UIAlertAction(title: "No", style: .default)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    func showLastTrack() {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded:false)
            let realm = try Realm(configuration: config)
            
            let coordinates = realm.objects(CoordinateEntity.self)
            
            guard !coordinates.isEmpty else { return }
            
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            
            coordinates.forEach() { coordinate in
                routePath?.addLatitude(coordinate.latitude, longitude: coordinate.longitude)
            }
            
            route?.path = routePath
            route?.map = mapView
                        
            guard let firstDot = coordinates.first,
                  let lastDot = coordinates.last else { return }
                        
            let firstCoordinate = CLLocationCoordinate2D(latitude: firstDot.latitude, longitude: firstDot.longitude)
            let lastCoordinate = CLLocationCoordinate2D(latitude: lastDot.latitude, longitude: lastDot.longitude)
            let bounds = GMSCoordinateBounds(coordinate: firstCoordinate, coordinate: lastCoordinate)
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
            mapView.moveCamera(update)
            
        } catch { print(error) }
    }
    
    //MARK: - Actions
    
    @IBAction func updateLocation(_ sender: Any) {
        createTrack()
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func startTrack(_ sender: Any) {
        createTrack()
    }
    
    @IBAction func stopTrack(_ sender: Any) {
        writeTrack()
        locationManager?.stopUpdatingLocation()
        isActiveTrack = false
    }
    
    @IBAction func lastTrack(_ sender: Any) {
        if isActiveTrack {
            showConfirmation()
        } else {
            showLastTrack()
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toAuth()
    }
}

extension MapViewController {
    func configureMapStyle() {
            let style = "[" +
                "  {" +
                "    \"featureType\": \"all\"," +
                "    \"elementType\": \"geometry\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#242f3e\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"all\"," +
                "    \"elementType\": \"labels.text.stroke\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"lightness\": -80" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"administrative\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#746855\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"administrative.locality\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#d59563\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"poi\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#d59563\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"poi.park\"," +
                "    \"elementType\": \"geometry\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#263c3f\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"poi.park\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#6b9a76\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road\"," +
                "    \"elementType\": \"geometry.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#2b3544\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#9ca5b3\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.arterial\"," +
                "    \"elementType\": \"geometry.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#38414e\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.arterial\"," +
                "    \"elementType\": \"geometry.stroke\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#212a37\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.highway\"," +
                "    \"elementType\": \"geometry.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#746855\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.highway\"," +
                "    \"elementType\": \"geometry.stroke\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#1f2835\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.highway\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#f3d19c\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.local\"," +
                "    \"elementType\": \"geometry.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#38414e\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"road.local\"," +
                "    \"elementType\": \"geometry.stroke\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#212a37\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"transit\"," +
                "    \"elementType\": \"geometry\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#2f3948\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"transit.station\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#d59563\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"water\"," +
                "    \"elementType\": \"geometry\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#17263c\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"water\"," +
                "    \"elementType\": \"labels.text.fill\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"color\": \"#515c6d\"" +
                "      }" +
                "    ]" +
                "  }," +
                "  {" +
                "    \"featureType\": \"water\"," +
                "    \"elementType\": \"labels.text.stroke\"," +
                "    \"stylers\": [" +
                "      {" +
                "        \"lightness\": -20" +
                "      }" +
                "    ]" +
                "  }" +
            "]"
            do {
                mapView.mapStyle = try GMSMapStyle(jsonString: style)
            } catch {
                print(error)
            }
            
        }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate, isActiveTrack else { return }
        routePath?.add(coordinate)
        route?.path = routePath
        
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


