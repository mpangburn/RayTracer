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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Spheres", comment: "The title text for sphere list screen")
        tableView.tableFooterView = UIView()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Sphere.fetchRequest())
//        let deleteResult = try! context.execute(deleteRequest)

        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [dateSortDescriptor]
        let tracer = RayTracer.shared

        do {
            tracer.spheres = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sphere data")
        }

        if tracer.spheres.isEmpty {
            tracer.spheres.append(Sphere(string: "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05", context: context)!)
            tracer.spheres.append(Sphere(string: "8.0 -10.0 100.0 90.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05", context: context)!)
        }

         appDelegate.saveContext()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RayTracer.shared.spheres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SphereTableViewCell.className, for: indexPath) as! SphereTableViewCell
        let sphere = RayTracer.shared.spheres[indexPath.row]
        cell.titleLabel.text = "radius = \(sphere.radius.cleanValueString) at (\(sphere.center.x.cleanValueString), \(sphere.center.y.cleanValueString), \(sphere.center.z.cleanValueString))"
        cell.colorView.backgroundColor = UIColor(sphere.color)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSphereData(at: indexPath)
            RayTracer.shared.spheres.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    private func deleteSphereData(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "creationDate == %@", RayTracer.shared.spheres[indexPath.row].creationDate)
        let sphereToDelete = try! context.fetch(fetchRequest).first!
        context.delete(sphereToDelete)
        appDelegate.saveContext()
    }

    // MARK: - Navigation

    @IBAction func unwindToSpheresTableViewController(sender: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if let sourceViewController = sender.source as? AddEditSphereTableViewController {
            let tracer = RayTracer.shared
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let originalCreationDate = tracer.spheres[selectedIndexPath.row].creationDate
                deleteSphereData(at: selectedIndexPath)
                tracer.spheres[selectedIndexPath.row] = sourceViewController.sphere
                tracer.spheres[selectedIndexPath.row].creationDate = originalCreationDate
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: tracer.spheres.count, section: 0)
                tracer.spheres.append(sourceViewController.sphere)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

            appDelegate.saveContext()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "AddSphere":
            let destination = (segue.destination as! UINavigationController).viewControllers.first as! AddEditSphereTableViewController
            destination.title = NSLocalizedString("Add Sphere", comment: "The title text for the sphere adding screen")
        case "EditSphere":
            let destination = segue.destination as! AddEditSphereTableViewController
            destination.title = NSLocalizedString("Edit Sphere", comment: "The title text for the sphere editing screen")
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.sphere = RayTracer.shared.spheres[selectedRow]
        default:
            break
        }
    }
}
