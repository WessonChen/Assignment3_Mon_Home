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

class NewDeviceTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var addDeviceView: UIView!
    @IBOutlet weak var aNameTestField: UITextField!
    @IBOutlet var aAddDeviceView: UIView!
    @IBOutlet weak var isHeater: UISwitch!
    
    var thisRoom: Room?
    
    var newDevices = [NodeServer.DeviceInfo]()
    var deviceList = [NodeServer.DeviceInfo]()
    var deviceInCoreData = [Device]()
    var isAdding = false
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllDevice()
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadDeviceFromCoreData()
        self.tableView.reloadData()
        
        /*
         Get the height of the keyboard
         From: https://stackoverflow.com/questions/31774006/how-to-get-height-of-keyboard-swift
         Author: Nrv
         */
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewDeviceTableViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewDeviceTableViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        isAdding = false
    }
    
    @IBAction func cancelAddSocket(_ sender: Any) {
        Animation.animateOut(subView: aAddDeviceView)
        cleanTextField()
        isAdding = false
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
            isAdding = false
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
            if (isHeater.isOn) {
                theDevice?.type = "power-plug-heater"
            } else {
                theDevice?.type = selectedNewDevice.type
            }
            theDevice?.id = selectedNewDevice.id
            let room = thisRoom?.mutableSetValue(forKey: "hasDevices")
            room?.add(theDevice!)
            do{
                // save device into CoreData
                try self.managedObjectContext.save()
                
                // change type from power-plug to power-plug-heater if switch is on
                if (isHeater.isOn) {
                    theDevice?.type = "power-plug-heater"
                    NodeServer.sharedInstance.setTypeForDeviceById(id: (theDevice?.id)!, type: "power-plug-heater")
                }
            }
            catch let error{
                print("Could not save: \(error)")
            }
            Animation.animateOut(subView: aAddDeviceView)
            self.navigationController!.popViewController(animated: true)
            cleanTextField()
            isAdding = false
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
        isAdding = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewDeviceCell", for: indexPath) as! NewDeviceTableViewCell

        cell.newDeviceId.text = "ID: \(newDevices[indexPath.row].id)"
        switch(newDevices[indexPath.row].type){
        case "power-plug":
            cell.newDeviceLab.text = "Socket"
            cell.newDevicesImage.image = #imageLiteral(resourceName: "socket")
            break
        case "power-plug-heater":
            cell.newDeviceLab.text = "Heater"
            cell.newDevicesImage.image = #imageLiteral(resourceName: "heater")
            break
        case "lamp":
            cell.newDeviceLab.text = "Desk Lamp"
            cell.newDevicesImage.image = #imageLiteral(resourceName: "lamp")
            break
        case "light":
            cell.newDeviceLab.text = "Light Bulb"
            cell.newDevicesImage.image = #imageLiteral(resourceName: "lamp")
            break
        default:
            cell.newDeviceLab.text = "Unknow Device"
            cell.newDevicesImage.image = #imageLiteral(resourceName: "noImage")
            break
        }
        if isAdding {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
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
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        addDeviceView.center.y = keyboardHeight
        aAddDeviceView.center.y = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        addDeviceView.center = self.view.center
        aAddDeviceView.center = self.view.center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        aNameTestField.resignFirstResponder()
        return true
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
