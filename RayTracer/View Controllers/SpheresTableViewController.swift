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

    var tracer = RayTracer.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Spheres", comment: "The title text for sphere list screen")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Sphere.fetchRequest())
//        let deleteResult = try! context.execute(deleteRequest)

        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
//        let dateSortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
//        fetchRequest.sortDescriptors = [dateSortDescriptor]

        do {
            tracer.spheres = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sphere data")
        }

        if tracer.spheres.count == 0 {
            tracer.spheres.append(Sphere(string: "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05", context: context)!)
            tracer.spheres.append(Sphere(string: "8.0 -10.0 110.0 100.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05", context: context)!)
        }

         appDelegate.saveContext()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Accounts for unexpected sphere reordering after tracing
//        tracer.spheres.sort { ($0.creationDate as Date) < ($1.creationDate as Date) }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracer.spheres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SphereTableViewCell.className, for: indexPath) as! SphereTableViewCell
        cell.equationLabel.text = tracer.spheres[indexPath.row].equation(usingIntegers: true)
        cell.colorView.backgroundColor = UIColor(tracer.spheres[indexPath.row].color)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSphereData(at: indexPath)
            tracer.spheres.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    private func deleteSphereData(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "creationDate == %@", self.tracer.spheres[indexPath.row].creationDate)
        let sphereToDelete = try! context.fetch(fetchRequest).first!
        context.delete(sphereToDelete)
        appDelegate.saveContext()
    }

    // MARK: - Navigation

    @IBAction func unwindToSpheresTableViewController(sender: UIStoryboardSegue) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        if let sourceViewController = sender.source as? AddEditSphereTableViewController {
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
            guard let selectedRow = tableView.indexPathForSelectedRow?.row else { return }
            destination.sphere = tracer.spheres[selectedRow]
        default:
            break
        }
    }
}
