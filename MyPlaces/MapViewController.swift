//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Doolot on 26/9/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var place: Place!
    let annotetionIdentifier = "annotetionIdentifier"
    
    @IBOutlet var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupPlaceMark()
   }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
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
}
