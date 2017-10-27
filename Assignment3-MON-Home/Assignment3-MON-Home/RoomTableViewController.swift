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

protocol addRoomDelegate{
    func addRoom(room: Room)
}

class RoomTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, addRoomDelegate {

    @IBOutlet var addRoomView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    
    let types = ["Bedroom", "Dining Room", "Games Room", "Kitchen", "Living Room"]
    
    var myRoomList: [NSManagedObject] = []
    var myRoom: RoomTable?
    var managedObjectContext: NSManagedObjectContext
    var currentType = ""
    var delegate: addRoomDelegate?
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = appDelegate.persistentContainer.viewContext
        super.init(coder: aDecoder)!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RoomTable")
        do{
            var result = try self.managedObjectContext.fetch(fetchRequest)
            if result.count == 0
            {
                self.myRoom = RoomTable.init(entity: NSEntityDescription.entity(forEntityName: "RoomTable", in: self.managedObjectContext)!, insertInto: self.managedObjectContext)
            } else{
                self.myRoom = result[0] as? RoomTable
                //self.myRoomList = myRoom?.contains?.allObjects as! [Room]
            }
        }
        catch{
            let fetchError = error as NSError
            print(fetchError)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if nameText.text == "" || currentType == ""{
            generateAlert(title: "It should have a room name.")
        } else {
            let newRoom = NSEntityDescription.insertNewObject(forEntityName: "Room", into: managedObjectContext) as? Room
            newRoom!.name = nameText.text
            newRoom!.type = currentType
            do{
                try self.managedObjectContext.save()
            }
            catch let error{
                print("Could not save: \(error)")
            }
            addRoom(room: newRoom!)
            animateOut()
        }
    }
    
    func addRoom(room: Room) {
        self.myRoom?.addRoom(value: room)
        saveRecords()
    }
    
    func saveRecords()
    {
        do{
            try self.managedObjectContext.save()
        }
        catch let error{
            print("Could not save: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myRoomList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        
        let r: Room = self.myRoomList[indexPath.row] as! Room
        
        cell.roomLabel.text = r.name
        switch(r.type) {
        case "Bed Room"?:
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

    func generateAlert(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
