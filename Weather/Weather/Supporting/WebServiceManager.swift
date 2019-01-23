//
//  WebServiceManager.swift
//  Weather
//
//  Created by Software Engineer on 1/24/19.
//  Copyright © 2019 Benjamin Chris. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WebServiceManager: NSObject {
    
    static let manager = WebServiceManager()
    
    private func apiUrl(_ method: String, params: String) -> String {
        return "\(AppConfig.ThirdPartyAPI.apiBaseUrl)\(method)?appid=\(AppConfig.ThirdPartyAPI.openWeatherMapAPIKey)&\(params)&units=metric"
    }
    
    func loadCurrentWeather(coordinate: CLLocationCoordinate2D, completion: @escaping (Weather?, String?) ->()) {
        
        guard let url = URL(string: apiUrl("weather", params:"lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")) else {
            completion(nil, "Developer bug: Invalid call")
            return
        }
        
        print(url.absoluteString)
        
        Alamofire.request(url).responseJSON { (response) in
            
            switch response.result {
            case .success(let json):
                print("success with JSON: \(json)")
                if let data = json as? [String:Any] {
                    if let weather = Weather(JSON: data) {
                        completion(weather, nil)
                        return
                    }
                }
                completion(nil, "Data parsing error.")
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
        
        
    }
    
}
