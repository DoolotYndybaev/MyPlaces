//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Doolot on 26/9/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var place = Place()
    let annotetionIdentifier = "annotetionIdentifier"
    let locationMananger = CLLocationManager()
    let regionMeters = 1000.00
    var incomeSegueIdentifier = ""
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mapPinImage: UIImageView!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressLabel.text = ""
        locationMananger.delegate = self
        mapView.delegate = self
        setupMapView()
        checkLocationServices()
   }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func centerViewInUserLocation(_ sender: Any) {
        
        showUserLocation()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    private func setupMapView() {
        if incomeSegueIdentifier == "showPlace" {
            setupPlaceMark()
            mapPinImage.isHidden = true
            adressLabel.isHidden = true
            doneButton.isHidden = true
        }
    }
    
    private func setupPlaceMark() {
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placeMarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placeMarks = placeMarks else { return }
            
            let placeMark = placeMarks.first
            
            let annotetion = MKPointAnnotation()
            annotetion.title = self.place.name
            annotetion.subtitle = self.place.type
            
            guard let placeMarkLocation = placeMark?.location else { return }
            
            annotetion.coordinate = placeMarkLocation.coordinate
            
            self.mapView.showAnnotations([annotetion], animated: true)
            self.mapView.selectAnnotation(annotetion, animated: true)
            
        }
    }
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setuplocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are Disabled",
                               message: "To enable it go: Settings -> Privacy -> Location services and torn on")
            }
        }
    }
    private func setuplocationManager() {
        locationMananger.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func checkLocationAuthorization() {
        switch locationMananger.authorizationStatus {
        case .notDetermined:
            locationMananger.requestWhenInUseAuthorization()
        case .restricted:
            //show allert Controller
            break
        case .denied:
            //show allert Controller
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAdress" {
                showUserLocation()
            }
            break
        @unknown default:
            print("New case is available")
        }
    }
    private func showUserLocation() {
        if let location = locationMananger.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    // CLLocation - Координаты
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotetionView = mapView.dequeueReusableAnnotationView(withIdentifier: annotetionIdentifier) as? MKMarkerAnnotationView // Отвечает за булавку на нашей карте - MKMarkerAnnotationView
        
        if annotetionView == nil {
            annotetionView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotetionIdentifier)
            annotetionView?.canShowCallout = true
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotetionView?.rightCalloutAccessoryView = imageView
        }
        
        
     
        return annotetionView
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        //CLGeocoder Отвечает за преоброзование географических карт и географических названий
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(center) { (placeMarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placeMarks = placeMarks else { return }
           
            let placeMark = placeMarks.first
            let streetName = placeMark?.thoroughfare
            let buildNumber = placeMark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil &&  buildNumber != nil {
                self.adressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.adressLabel.text = "\(streetName!)"
                } else {
                    self.adressLabel.text = ""
                }
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
