//
//  ViewController.swift
//  googleintegration
//
//  Created by Chucks Mac Book on 11/10/17.
//  Copyright © 2017 Chucks Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapsViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    // You don't need to modify the default init(nibName:bundle:) method.
    var targetLong: Double = 0.0000
    var targetLat: Double = 0.0000
    var mView: GMSMapView?
    //current start point-- this will get updated during the didViewLoad
    var startlong: Double = 00.00
    var startlat: Double = 0.00
    let zm: Float = 15.0
    // gsmarker array
    var arrMarkers = [GMSMarker?]()
    //corelocation
    let manager = CLLocationManager()
    
    override func loadView() {
        startlat = 37.37
        startlong = -121.90
    let camera = GMSCameraPosition.camera(withLatitude:  37.37, longitude: -121.90, zoom: 13.0)
        //mapView.mapType = .satellite
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        mView = mapView // set it at the class level
        mapView.delegate = self
        
        self.view = mapView // not include in
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }

        dropMarker(latitude: startlat, longitude: startlong, targetIconType: "home")

        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        // we want to get the best and accurate data
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // only need to get the husers location when using the app
        manager.requestWhenInUseAuthorization()
        // manager will start updating the location live.
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
//        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
//        map.setRegion(region, animated: true)
//        self.map.showsUserLocation = true
        print (location.coordinate.latitude, location.coordinate.longitude, "this is the coordinate")
         startlong = location.coordinate.longitude
        startlat = location.coordinate.latitude
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        /// This function is based on the users tap on the screen.  It returns the coordinates.

        let location1 = CLLocation(latitude: targetLat, longitude: targetLong)// this is the tartget
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) // this is the chosen target.
        
        if targetLong != 0.0000 {
            // get distance from this click to the target
            dropMarker(latitude: coordinate.latitude, longitude: coordinate.longitude, targetIconType: "explosion")
            let distanceToTarget = getDistanceByPoint(location1, point2: location2)
            if distanceToTarget >= 10000.000 {
                print("You're to far")
            } else if distanceToTarget < 10000.000 && distanceToTarget >= 5000.000{
                print("You're getting closer. you're distance : ", String(distanceToTarget))
            } else if distanceToTarget < 5000.000 && distanceToTarget >= 2500.000{
                print("You're super close ", String(distanceToTarget))
            } else {
                print("You hit it. your distance : ", String(distanceToTarget))
            }
            //
            
        } else {
            // set the target where you want
            print("target has been set")
            targetLong = coordinate.longitude
            targetLat = coordinate.latitude
            dropMarker(latitude: targetLat, longitude: targetLong, targetIconType: "target")
        }
        
    }
    
    func dropMarker(latitude: Double, longitude: Double, targetIconType: String){
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //marker.tracksViewChanges = false
        
        if targetIconType == "home" {
            // this will set the intial location
            marker.icon = GMSMarker.markerImage(with: .red)
        } else if targetIconType == "target" {
            // this will set the intial location
            marker.icon = GMSMarker.markerImage(with: .blue)
        }
        else if targetIconType == "explosion" {
            // this is the shot fired
            // adjust the color of the image
            let explosionpng = UIImage(named: "exp2")!.withRenderingMode(.alwaysTemplate)
            let markerView = UIImageView(image: explosionpng)
            markerView.tintColor = .red
            
            if arrMarkers.count != 0 {
                // if there are shots fired, then change color of the previous shots.
                
                arrMarkers[arrMarkers.count-1]!.iconView?.tintColor = .blue
            }
            marker.iconView = markerView
            arrMarkers.append(marker)
        }
        marker.map = mView
    }
    
    func getDistanceByPoint(_ point1: CLLocation, point2: CLLocation)-> Double{
        let distance = point1.distance(from: point2)
        print(distance, "This is the distance")
        return distance
    }
}

