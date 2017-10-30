//
//  NewDeviceTableViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class NewDeviceTableViewController: UITableViewController {
    
    var thisRoom: Room?
    
    var newDevices = [[String]]()
    var deviceHeater = ["Heater", "111"]
    var deviceSocket = ["Socket", "222"]
    var deviceLamp = ["Lamp", "333"]
    var isHeaterAdded = false
    var isSocketAdded = false
    var isLampAdded = false
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        var devices = [Device]()
        
        do {
            devices = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        for each in devices {
            if each.id == deviceHeater[1] {
                isHeaterAdded = true
            } else if each.id == deviceSocket[1] {
                isSocketAdded = true
            } else if each.id == deviceLamp[1] {
                isLampAdded = true
            }
        }
        
        if !isHeaterAdded {
            newDevices.append(deviceHeater)
        }
        if !isSocketAdded {
            newDevices.append(deviceSocket)
        }
        if !isLampAdded {
            newDevices.append(deviceLamp)
        }
    }
    
    /*
    func getJSON() {
        let urlString = ""
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let currentDevice = parsedData["name"] as! [String:Any]
                    let deviceId = currentDevice["id"] as! String
                    let deviceType = currentDevice["type"] as! String
                    let newDevice = [deviceId, deviceType]
                    self.newDevices.append(newDevice)
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var selectedNewDevice = [String]()
        selectedNewDevice = newDevices[indexPath.row]
        let theDevice = NSEntityDescription.insertNewObject(forEntityName: "Device", into: managedObjectContext) as? Device
        theDevice?.name = "testName"
        theDevice?.type = selectedNewDevice[0]
        theDevice?.id = selectedNewDevice[1]
        let room = thisRoom?.mutableSetValue(forKey: "hasDevices")
        room?.add(theDevice!)
        do{
            try self.managedObjectContext.save()
        }
        catch let error{
            print("Could not save: \(error)")
        }
        self.navigationController!.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceCell", for: indexPath) as! NewDeviceTableViewCell
        
        let theDevice = newDevices[indexPath.row]
        
        cell.newDeviceLab.text = theDevice[0]
        switch(cell.newDeviceLab.text){
        case "Socket"?:
            cell.newDevicesImage.image = #imageLiteral(resourceName: "socket")
            break
        case "Heater"?:
            cell.newDevicesImage.image = #imageLiteral(resourceName: "heater")
            break
        case "Lamp"?:
            cell.newDevicesImage.image = #imageLiteral(resourceName: "lamp")
            break
        default:
            cell.newDevicesImage.image = #imageLiteral(resourceName: "noImage")
            break
        }
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newDevices.count
    }
}
