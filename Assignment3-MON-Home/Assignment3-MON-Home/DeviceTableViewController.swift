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
        switch(theDevice.type){
        case "Socket"?:
            cell.deviceImage.image = #imageLiteral(resourceName: "socket")
            break
        case "Heater"?:
            cell.deviceImage.image = #imageLiteral(resourceName: "heater")
            break
        case "Lamp"?:
            cell.deviceImage.image = #imageLiteral(resourceName: "lamp")
            break
        default:
            cell.deviceImage.image = #imageLiteral(resourceName: "noImage")
            break
        }
        return cell
    }
    
    var number = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        number = indexPath.row
        /*
        if devices[indexPath.row].type == "Socket" {
            self.performSegue(withIdentifier: "socketDetailSegue", sender: indexPath);
        } else if devices[indexPath.row].type == "Heater" {
            self.performSegue(withIdentifier: "heaterDetailSegue", sender: indexPath);
        } else {
            self.performSegue(withIdentifier: "lampDetailSegue", sender: indexPath);
        }
        */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeviceSegue"
        {
            let controller: NewDeviceTableViewController = segue.destination as! NewDeviceTableViewController
            controller.thisRoom = self.thisRoom
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
