//
//  MapViewController.swift
//  RouteTracker
//
//  Created by Denis Molkov on 03.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerButton: UIButton!

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
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
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
    
    //MARK: - Actions
    
    @IBAction func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
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
        guard let coordinate = locations.first?.coordinate else { return }
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        
        mapView.camera = camera
        
        addMarker(coordinate: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
