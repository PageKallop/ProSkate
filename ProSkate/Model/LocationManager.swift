//
//  LocationManager.swift
//  ProSkate
//
//  Created by Page Kallop on 3/21/21.
//

import Foundation
import CoreLocation

struct searchLocation {
    
    let title: String
    let coordinates: CLLocationCoordinate2D?
}


class LocationManager: NSObject {
    
   static let sharedLocation = LocationManager()

    //Gets users loction and turns it to a string
    public func findLocation(with query: String, completion: @escaping (([searchLocation]) -> Void)) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            let models: [searchLocation] = places.compactMap({ place in
                
                var name = ""
                
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ",\(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ",\(country)"
                }
                
                print(place)
                
                let results = searchLocation(title: name, coordinates: place.location?.coordinate)
            
                return results
            })
            
            completion(models)
        }
        
    }
}

