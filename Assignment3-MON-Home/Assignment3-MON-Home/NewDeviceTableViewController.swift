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
    
    @IBAction func cancelAddDevice(_ sender: Any) {
        animateOut()
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
            var selectedNewDevice = [String]()
            selectedNewDevice = newDevices[addRow]
            let theDevice = NSEntityDescription.insertNewObject(forEntityName: "Device", into: managedObjectContext) as? Device
            theDevice?.name = trimString(inputString: nameTextField.text!)
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
            animateOut()
            self.navigationController!.popViewController(animated: true)
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
    
    func animateIn() {
        self.view.addSubview(addDeviceView)
        addDeviceView.center = self.view.center
        
        addDeviceView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
        addDeviceView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.addDeviceView.alpha = 1
            self.addDeviceView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addDeviceView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
            self.addDeviceView.alpha = 0
        }) {(success:Bool) in
            self.addDeviceView.removeFromSuperview()
        }
    }
    
    var addRow = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        addRow = indexPath.row
        animateIn()
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
