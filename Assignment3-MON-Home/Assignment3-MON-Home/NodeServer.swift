//
//  NodeServer.swift
//  Assignment3-MON-Home
//
//  Created by Mike Phan on 31/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import Foundation

// THIS CLASS HAS BEEN MODIFIED FROM THE ORIGINAL
// Author: Christina Moulton
// Link: https://grokswift.com/json-swift-4/
// Date 1st November 2017
class NodeServer{
    
    private init(){
        
    }
    
    static let sharedInstance = NodeServer()
    
    let host = "http://192.168.1.15"
    let port = "3000"
    let getAllDeviceInfoLink = "getalldeviceinfo"
    let getAllDeviceSettingLink = "getalldevicesetting"
    
    enum BackendError: Error {
        case urlError(reason: String)
        case objectSerialization(reason: String)
    }
    
    struct DeviceInfo: Codable {
        var id: String
        var type: String
        var model: String
        var address: String
        var isPowerOn: Bool
        var isRegister: Bool
    }
    
    struct DeviceSetting: Codable{
        var id: String
        var startTime: String
        var stopTime: String
        var minTemp: String
        var maxTemp: String
        var brightness: String
        var isOnPeriod: Bool
        var isSettingEnabled: Bool
        var type: String
        var isManuallyController: Bool
    }
    
    func getAllDeviceInfo(completionHandler: @escaping ([DeviceInfo]?, Error?) -> Void) {
        // Set up URLRequest with URL
        
        let endpoint = "\(host):\(port)/\(getAllDeviceInfoLink)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // handle response to request
            // check for error
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = BackendError.objectSerialization(reason: "No data in response")
                completionHandler(nil, error)
                return
            }
            
            // parse the result as JSON
            // then create a Todo from the JSON
            let decoder = JSONDecoder()
            do {
                let devicesInfo = try decoder.decode([DeviceInfo].self, from: responseData)
                completionHandler(devicesInfo, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        })
        task.resume()
    } 
    
    func getAllDeviceInfo(completionHandler: @escaping ([DeviceSetting]?, Error?) -> Void) {
        // Set up URLRequest with URL
        
        let endpoint = "\(host):\(port)/\(getAllDeviceSettingLink)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completionHandler(nil, error)
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // handle response to request
            // check for error
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = BackendError.objectSerialization(reason: "No data in response")
                completionHandler(nil, error)
                return
            }
            
            // parse the result as JSON
            // then create a Todo from the JSON
            let decoder = JSONDecoder()
            do {
                let deviesSetting = try decoder.decode([DeviceSetting].self, from: responseData)
                completionHandler(deviesSetting, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
    
}
