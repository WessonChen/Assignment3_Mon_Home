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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var addDeviceView: UIView!
    @IBOutlet weak var aNameTestField: UITextField!
    @IBOutlet var aAddDeviceView: UIView!
    
    var thisRoom: Room?
    
    var newDevices = [NodeServer.DeviceInfo]()
    var deviceList = [NodeServer.DeviceInfo]()
    var deviceInCoreData = [Device]()
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllDevice()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadDeviceFromCoreData()
        
        self.tableView.reloadData()
    }
    
    func loadDeviceFromCoreData(){
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        deviceInCoreData.removeAll()
        do {
            deviceInCoreData = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
    }
    
    func findDeviceInCoreDataByDeviceId(id: String) -> Int{
        for device in deviceInCoreData{
            if( device.id == id){
                return 1
            }
        }
        return 0
    }
    
    @IBAction func cancelAddDevice(_ sender: Any) {
        Animation.animateOut(subView: addDeviceView)
        cleanTextField()
    }
    
    @IBAction func cancelAddSocket(_ sender: Any) {
        Animation.animateOut(subView: aAddDeviceView)
        cleanTextField()
    }
    
    func cleanTextField() {
        nameTextField.text?.removeAll()
        aNameTestField.text?.removeAll()
    }
    
    @IBAction func finishAddDevice(_ sender: Any) {
        var devices = [Device]()
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        do {
            devices = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        var isValid = true
        for each in devices {
            if each.name == trimString(inputString: nameTextField.text!) {
                isValid = false
            }
        }
        
        if trimString(inputString: nameTextField.text!) == "" {
            generateAlert(title: "It should have a device name.")
        } else if isValid {
            let selectedNewDevice = newDevices[addRow]
            let theDevice = NSEntityDescription.insertNewObject(forEntityName: "Device", into: managedObjectContext) as? Device
            theDevice?.name = trimString(inputString: nameTextField.text!)
            theDevice?.type = selectedNewDevice.type
            theDevice?.id = selectedNewDevice.id
            let room = thisRoom?.mutableSetValue(forKey: "hasDevices")
            room?.add(theDevice!)
            do{
                try self.managedObjectContext.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
            Animation.animateOut(subView: addDeviceView)
            self.navigationController!.popViewController(animated: true)
            cleanTextField()
        } else {
            generateAlert(title: "You cannot use the same device name twice.")
        }
    }
    
    @IBAction func finishAddSocket(_ sender: Any) {
        
        var devices = [Device]()
        let deviceRequest:NSFetchRequest<Device> = Device.fetchRequest()
        do {
            devices = try managedObjectContext.fetch(deviceRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
        
        var isValid = true
        for each in devices {
            if each.name == trimString(inputString: aNameTestField.text!) {
                isValid = false
            }
        }
        
        if trimString(inputString: aNameTestField.text!) == "" {
            generateAlert(title: "It should have a device name.")
        } else if isValid {
            let selectedNewDevice = newDevices[addRow]
            let theDevice = NSEntityDescription.insertNewObject(forEntityName: "Device", into: managedObjectContext) as? Device
            theDevice?.name = trimString(inputString: aNameTestField.text!)
            theDevice?.type = selectedNewDevice.type
            theDevice?.id = selectedNewDevice.id
            let room = thisRoom?.mutableSetValue(forKey: "hasDevices")
            room?.add(theDevice!)
            do{
                try self.managedObjectContext.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
            Animation.animateOut(subView: aAddDeviceView)
            self.navigationController!.popViewController(animated: true)
            cleanTextField()
        } else {
            generateAlert(title: "You cannot use the same device name twice.")
        }
    }
    
    func trimString (inputString: String) -> String {
        return inputString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func generateAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
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
    
    var addRow = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        addRow = indexPath.row
        let theDevice = newDevices[addRow]
        if theDevice.type != "power-plug" {
            Animation.animateIn(mainView: self.view, subView: addDeviceView)
        } else {
            Animation.animateIn(mainView: self.view, subView: aAddDeviceView)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceCell", for: indexPath) as! NewDeviceTableViewCell
        
        cell.newDeviceLab.text = newDevices[indexPath.row].type
        cell.newDeviceId.text = newDevices[indexPath.row].id
        switch(newDevices[indexPath.row].type){
        case "power-plug":
            cell.newDevicesImage.image = #imageLiteral(resourceName: "socket")
            break
        case "power-plug-heater":
            cell.newDevicesImage.image = #imageLiteral(resourceName: "heater")
            break
        case "lamp":
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

    func getAllDevice() {
        NodeServer.sharedInstance.getAllDeviceInfo(completionHandler: { devices, error in
            if let error = error {
                // got an error in getting the data, need to handle it
                print(error)
                return
            }
            guard let devices = devices else {
                print("error getting first todo: result is nil")
                return
            }
            // success
            self.deviceList.removeAll()
            for device in devices{
                self.deviceList.append(device)
                
                if(self.findDeviceInCoreDataByDeviceId(id: device.id) == 0){
                        self.newDevices.append(device)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}
