//
//  MapSelectViewController.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import MapKit

class MapSelectViewController: UIViewController {

    @IBOutlet weak var mapViewMain: MKMapView!
    var selectedCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up navigation
        self.setupNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Tricky,  in order to show the simple clear back icon on the navitation bar in the nested viewcontrollers
        self.navigationItem.title = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sid_weather_details" {
            let controller = segue.destination as! WeatherDetailsViewController
            controller.coordinate = self.selectedCoordinate
        }
    }
    
    func setupNavigation() {
        guard let navigationController = self.navigationController else { return }
        
        navigationController.isNavigationBarHidden = false
        self.navigationItem.title = "Weather"
        self.navigationItem.hidesBackButton = true
        
        let rightBar = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(onHistory))
        self.navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc func onHistory() {
        
    }

}

// Functions for the map control

extension MapSelectViewController: MKMapViewDelegate {
    
    // Add single tap gesture,
    // In order to prevent event firing for double tap, added empty doubleTapGesture
    
    func setupMapGesture() {
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        singleTapGesture.numberOfTapsRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.require(toFail: doubleTapGesture)
        
        self.mapViewMain.addGestureRecognizer(singleTapGesture)
        self.mapViewMain.addGestureRecognizer(doubleTapGesture)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        let touchPoint = gestureRecognizer.location(in: self.mapViewMain)
        let coordinate = self.mapViewMain.convert(touchPoint, toCoordinateFrom: self.mapViewMain)
        
        self.mapViewMain.removeAnnotations(self.mapViewMain.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = String(format: "(%.5f, %.5f)", coordinate.latitude, coordinate.longitude)
        annotation.subtitle = "Tap to see weather"
        annotation.coordinate = coordinate
        
        self.mapViewMain.addAnnotation(annotation)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.selectedCoordinate = coordinate
            self.mapViewMain.selectAnnotation(annotation, animated: true)
        }
    }
    
    // Empty handle to prevent unnecessary firing when double tap
    @objc func handleDoubleTap() {
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isEnabled = true
            annotationView!.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = button
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let tapGestureOnAnnotationView = UITapGestureRecognizer(target: self, action: #selector(openWeather))
        view.addGestureRecognizer(tapGestureOnAnnotationView)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let _ = view.annotation as? MKPointAnnotation {
            self.openWeather()
        }
    }
    
    @objc func openWeather() {
        self.performSegue(withIdentifier: "sid_weather_details", sender: nil)
    }
}
