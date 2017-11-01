//
//  DeviceTableViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 30/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DeviceTableViewController: UITableViewController {

    var thisRoom: Room?
    var devices = [Device]()
    var thisDevice: Device?
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        fRequest.predicate = NSPredicate(format: "%K == %@", "inRoom.name", (thisRoom?.name!)!)
        do {
            devices = try self.managedObjectContext.fetch(fRequest) as! [Device]
            self.tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceTableViewCell
        
        let theDevice = devices[indexPath.row]
        
        cell.deviceLab.text = theDevice.name
        cell.deviceId.text = "ID: \(theDevice.id!)"
        switch(theDevice.type!){
        case "power-plug":
            cell.deviceImage.image = #imageLiteral(resourceName: "socket")
            break
        case "power-plug-heater":
            cell.deviceImage.image = #imageLiteral(resourceName: "heater")
            break
        case "Lamp":
            cell.deviceImage.image = #imageLiteral(resourceName: "lamp")
            break
        case "light":
            cell.deviceImage.image = #imageLiteral(resourceName: "lamp")
            break
        default:
            cell.deviceImage.image = #imageLiteral(resourceName: "noImage")
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let delDevice: Device = devices[indexPath.row]
            managedObjectContext.delete(delDevice)
            do{
                try self.managedObjectContext.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
            self.loadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisDevice = devices[indexPath.row]
        
        switch(devices[indexPath.row].type!){
        case "power-plug":
            self.performSegue(withIdentifier: "socketDetailSegue", sender: indexPath);
            break
        case "power-plug-heater":
            self.performSegue(withIdentifier: "heaterDetailSegue", sender: indexPath);
            break
        case "Lamp":
            self.performSegue(withIdentifier: "lampDetailSegue", sender: indexPath);
            break
        case "light":
            self.performSegue(withIdentifier: "lampDetailSegue", sender: indexPath);
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier){
        case "addDeviceSegue"?:
            let controller: NewDeviceTableViewController = segue.destination as! NewDeviceTableViewController
            controller.thisRoom = self.thisRoom
            break
        case "socketDetailSegue"?:
            let controller: SocketViewController = segue.destination as! SocketViewController
            controller.thisDevice = self.thisDevice
            break
        case "heaterDetailSegue"?:
            let controller: HeaterViewController = segue.destination as! HeaterViewController
            controller.thisDevice = self.thisDevice
            break
        case "lampDetailSegue"?:
            let controller: LampViewController = segue.destination as! LampViewController
            controller.thisDevice = self.thisDevice
            break
        default:
            break
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.devices.count
    }
}
