//
//  SpheresTableViewController.swift
//  RayTracer-iOS
//
//  Created by Michael Pangburn on 7/7/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData


class SpheresTableViewController: UITableViewController {

    var spheres: [Sphere] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Spheres", comment: "The title text for sphere list screen")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Sphere.fetchRequest())
//        let deleteResult = try! context.execute(deleteRequest)

        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        do {
            spheres = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sphere data")
        }

        if spheres.count < 2 {
            spheres.append(Sphere(string: "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05", context: context)!)
            spheres.append(Sphere(string: "8.0 -10.0 110.0 100.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05", context: context)!)
        }

         appDelegate.saveContext()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spheres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SphereTableViewCell.className, for: indexPath) as! SphereTableViewCell
        cell.equationLabel.text = spheres[indexPath.row].equation(usingIntegers: true)
        cell.colorView.backgroundColor = UIColor(spheres[indexPath.row].color)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "creationDate == %@", self.spheres[indexPath.row].creationDate)
            let sphereToDelete = try! context.fetch(fetchRequest).first!
            context.delete(sphereToDelete)
            appDelegate.saveContext()

            self.spheres.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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

    // MARK: - Navigation

    @IBAction func unwindToSpheresTableViewController(sender: UIStoryboardSegue) { }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "AddSphere":
            let destination = segue.destination as! AddEditSphereTableViewController
            destination.title = NSLocalizedString("Add Sphere", comment: "The title text for the sphere adding screen")
        case "EditSphere":
            let destination = segue.destination as! AddEditSphereTableViewController
            destination.title = NSLocalizedString("Edit Sphere", comment: "The title text for the sphere editing screen")
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            destination.sphere = spheres[selectedRow]
        default:
            break
        }
    }


}
