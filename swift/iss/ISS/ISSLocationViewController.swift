//
//  ISSLocationViewController.swift
//  ISS
//
//  Created by Michael Wells on 7/28/15.
//  Copyright (c) 2015 Michaelosity. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ISSLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotation = MKPointAnnotation()
    var refreshTimer: NSTimer?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

//        var refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshButtonTapped:")
//        navigationItem.rightBarButtonItem = refreshButton
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        refreshLocation()
        
        refreshTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "refreshTimer:", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
    
        super.viewDidDisappear(animated)
        
        refreshTimer?.invalidate()
    }
    
    // MARK: Button Handlers
    
    func refreshButtonTapped(sender: AnyObject?) {

        refreshLocation()
    }
    
    // MARK: Timer
    
    func refreshTimer(timer: NSTimer) {
        
        if timer.valid {
            refreshLocation()
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKPointAnnotation) {
            var annotationView = mapView?.dequeueReusableAnnotationViewWithIdentifier("iss")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "iss")
                annotationView?.image = UIImage(named: "ISSIcon")
                return annotationView
            }
        
            annotationView?.annotation = annotation
            return annotationView
        }
        
        return nil
    }
    
    // MARK: Private Implementation
    
    private func refreshLocation() {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.refreshLocationImpl()
        }
    }
    
    private func refreshLocationImpl() {
        
        // Swift 1.2 stupidity to work around non-static; this is fixed supposedly in Swift 2.0
        struct StaticEnvironment {
            private static let url = NSURL(string: "http://api.open-notify.org/iss-now.json")!
            private static let request = NSURLRequest(URL: url)
            private static let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            static var requestId: Int = 0
            static let session = NSURLSession(configuration: config)
        }
        
        println("refreshLocation: starting request #\(StaticEnvironment.requestId)...")

        let task = StaticEnvironment.session.dataTaskWithRequest(StaticEnvironment.request, completionHandler: { (data, response, error) in
            var jsonError: NSError?
            if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &jsonError) as? NSDictionary {
                println("refreshLocation: JSON")
                println(json)
                if let message = json["message"] as? String where message == "success" {
                    if let position = json["iss_position"] as? NSDictionary {
                        if let latitude = position["latitude"] as? Double, longitude = position["longitude"] as? Double {
                            println("refreshLocation: position is \(latitude), \(longitude)")
                            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.annotation.coordinate = coordinate
                                self.mapView.centerCoordinate = coordinate
                                if count(self.mapView.annotations) == 0 {
                                    self.mapView.addAnnotation(self.annotation)
                                }
                            }
                        } else {
                            println("!!! refreshLocation: latitude or longitude was not a Double as expected")
                        }
                    } else {
                        println("!!! refreshLocation: position was not an NSDictionary as expected")
                    }
                } else {
                    println("!!! refreshLocation: message was not \"success\" as expected")
                }
            } else {
                println("!!! refreshLocation: \(jsonError?.localizedDescription)")
            }
            println("refreshLocation: done with request #\(StaticEnvironment.requestId)")
        })
        
        task.resume()
        
        StaticEnvironment.requestId++
    }
}

