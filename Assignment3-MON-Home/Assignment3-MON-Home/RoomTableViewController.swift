//
//  RoomTableViewController.swift
//  Assignment3-MON-Home
//
//  Created by weicheng chen on 26/10/17.
//  Copyright © 2017 Minh&Weicheng. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class RoomTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var addRoomView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    
    let types = ["Bedroom", "Dining Room", "Games Room", "Kitchen", "Living Room"]
    var currentType = "Bedroom"
    
    var rooms = [Room]()
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
   }
    
    func loadData(){
        let roomRequest:NSFetchRequest<Room> = Room.fetchRequest()
        
        do {
            rooms = try managedObjectContext.fetch(roomRequest)
            self.tableView.reloadData()
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }

    func animateIn() {
        self.view.addSubview(addRoomView)
        addRoomView.center = self.view.center
        
        addRoomView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
        addRoomView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.addRoomView.alpha = 1
            self.addRoomView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addRoomView.transform = CGAffineTransform.init(translationX: 1.3, y: 1.3)
            self.addRoomView.alpha = 0
        }) {(success:Bool) in
            self.addRoomView.removeFromSuperview()
        }
    }
    
    @IBAction func addRoom(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func finishAddRoom(_ sender: Any) {
        createRoom()
    }
    
    @IBAction func cancelAddRoom(_ sender: Any) {
        animateOut()
    }
    
    func createRoom() {
        var isValid = true
        for each in rooms {
            if each.name == trimString(inputString: nameText.text!) {
                isValid = false
            }
        }
        if trimString(inputString: nameText.text!) == "" {
            generateAlert(title: "It should have a room name.")
        } else if isValid {
            let newRoom = Room(context: managedObjectContext)
            newRoom.name = trimString(inputString: nameText.text!)
            newRoom.type = currentType
            
            do {
                try self.managedObjectContext.save()
                self.loadData()
                animateOut()
            }catch {
                print("Could not save data \(error.localizedDescription)")
            }
        } else {
            generateAlert(title: "You cannot use the same room name twice.")
        }
        nameText.text = ""
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let delRoom: Room = rooms[indexPath.row]
            let fRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
            fRequest.predicate = NSPredicate(format: "%K == %@", "inRoom.name", delRoom.name!)
            var delList: [Device] = []
            do {
                delList = try self.managedObjectContext.fetch(fRequest) as! [Device]
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
            for each in delList {
                managedObjectContext.delete(each)
            }
            managedObjectContext.delete(delRoom)
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
    
    func trimString (inputString: String) -> String {
        return inputString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        
        let theRoom = rooms[indexPath.row]
        
        cell.roomLabel.text = theRoom.name
        switch(theRoom.type){
        case "Bedroom"?:
            cell.roomImage.image = #imageLiteral(resourceName: "bedroom")
            break
        case "Dining Room"?:
            cell.roomImage.image = #imageLiteral(resourceName: "diningRoom")
            break
        case "Games Room"?:
            cell.roomImage.image = #imageLiteral(resourceName: "game")
            break
        case "Kitchen"?:
            cell.roomImage.image = #imageLiteral(resourceName: "kitchen")
            break
        case "Living Room"?:
            cell.roomImage.image = #imageLiteral(resourceName: "livingRoom")
            break
        default:
            cell.roomImage.image = #imageLiteral(resourceName: "noImage")
            break
        }
        return cell
    }

    var number = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        number = indexPath.row
        self.performSegue(withIdentifier: "roomToDeviceSegue", sender: indexPath);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "roomToDeviceSegue"
        {
            let controller: DeviceTableViewController = segue.destination as! DeviceTableViewController
            controller.thisRoom = rooms[number]
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }


    func generateAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentType = types[row]
    }
}
