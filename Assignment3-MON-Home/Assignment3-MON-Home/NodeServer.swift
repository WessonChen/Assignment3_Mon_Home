//
//  NodeServer.swift
//  Assignment3-MON-Home
//
//  Created by Mike Phan on 31/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import Foundation

class NodeServer{
    
    private init(){
        
    }
    
    static let sharedInstance = NodeServer()
    
    let host = "http://192.168.1.15"
    let port = "3000"
    let getAllDeviceInfoLink = "getalldeviceinfo"
    let getAllDeviceSettingLink = ""
    
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
    
    func allDeviceInfo(completionHandler: @escaping ([DeviceInfo]?, Error?) -> Void) {
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
                let todos = try decoder.decode([DeviceInfo].self, from: responseData)
                completionHandler(todos, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        })
        task.resume()
    } 
    
    
}
