//
//  MapView.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//
//
import SwiftUI
import MapKit
import CoreLocation
//UIViewRepresentable allows the use of UI Kit Views in Swift UI.  It is a wrapper.
struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var peaks: Peaks
    
    @Environment(\.openURL) private var openURL


    let mapView = MKMapView()
    
    func updateMapType(type: MKMapType) {
        mapView.mapType = type
    }
    
    //protocol method
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        return mapView
    }
    //protocol method
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true //have the map view show the users location.  shows the blue pin to indicate current location.

        
        //access the landmarks binding from the MapView
        mapView.addAnnotations(peaks.highPeaks)
    
    }
    //how you create a delegate to recieve location manager events.
    func makeCoordinator() -> Coordinator {
        //pass in current view.  implicit return here since we only have one statement.
        Coordinator(self) //assign the coordinator which is going to serve as the delegate.
    }
    
    func zoomIn(annotation: MKAnnotation) {
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
    
    func zoomOut() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    
    //INNER COORDINATOR CLASS
    class Coordinator: NSObject, MKMapViewDelegate  {
        
        var parent: MapView //reference to outer class
        
        //the underscore allows the function to take arguments in a positional manner, as opposed to something like init(parent: parent)
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        //MARK: mapview delegate methods
        //If the user taps on either the left tag or the right tag after tapping on an annotation. control.tag = 0 means left button(tag), control.tag = 1 means right button(tag)
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
                let place = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: place)
                mapItem.name = view.annotation!.title ?? "Selected Location"
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options)
       
        }
        
        //this is called once for annotation created/added to the map.
        //if no view is returned, it uses the default pin
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            var view: MKMarkerAnnotationView
            let identifier = "Pin"
            
            if annotation is MKUserLocation {
                //return nil so that the default view is drawn.
                return nil
            }
            
            
            if annotation !== mapView.userLocation {
                
                //look for a view to reuse
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                    dequeuedView.annotation = annotation
                    //make the pin purple here too.
                    dequeuedView.markerTintColor = UIColor.purple
                    view = dequeuedView
                } else {
                    view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    
                    //customize pin
                    view.markerTintColor = .purple
                    view.animatesWhenAdded = true
                    view.canShowCallout = true  //this makes title and subtitle now required, not optional!
                    
                    let rightButton = UIButton(type: .detailDisclosure)
                    
                    rightButton.setImage(UIImage(systemName: "car"), for: .normal)
                    rightButton.tag = 0
                    
                    view.rightCalloutAccessoryView = rightButton
                }//create a new view
                
                return view
                
            }//not the users location
                
            return nil
        }//view for annotation.
        
        //this method is invoked when the useer taps on a pin.
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let annotation = view.annotation
            print("The title of the peak is \(String(describing: annotation?.title))")
        }
        
//        user scrolls and moves the map.
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        
    } //end of class Coordinator
}
