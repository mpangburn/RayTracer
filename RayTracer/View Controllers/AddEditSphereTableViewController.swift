//
//  AddEditSphereTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData

class AddEditSphereTableViewController: UITableViewController {

    var sphere: Sphere?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PointTableViewCell.nib(), forCellReuseIdentifier: PointTableViewCell.className)
        tableView.register(SingleValueTableViewCell.nib(), forCellReuseIdentifier: SingleValueTableViewCell.className)
        tableView.register(ColorTableViewCell.nib(), forCellReuseIdentifier: ColorTableViewCell.className)
        tableView.register(FinishTableViewCell.nib(), forCellReuseIdentifier: FinishTableViewCell.className)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tableView.endEditing(true)
    }

    private enum Row: Int {
        case center
        case radius
        case color
        case finish

        static let count = 4
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row(rawValue: indexPath.row)! {
        case .center:
            let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className) as! PointTableViewCell
            cell.delegate = self
            cell.point = sphere?.center ?? Point.zero
            return cell
        case .radius:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleValueTableViewCell.className) as! SingleValueTableViewCell
            cell.delegate = self
            cell.label.text = "Radius"
            cell.value = sphere?.radius ?? 0
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
            cell.delegate = self
            cell.color = sphere?.color ?? Color.black
            return cell
        case .finish:
            let cell = tableView.dequeueReusableCell(withIdentifier: FinishTableViewCell.className) as! FinishTableViewCell
            cell.delegate = self
            cell.finish = sphere?.finish ?? Finish.none
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? NSLocalizedString("ATTRIBUTES", comment: "The title of the section for sphere attribute editing") : ""
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("A sphere's finish consists of four components:\nambient - the percentage of ambient light reflected by the sphere\ndiffuse - the percentage of diffuse light reflected by the sphere\nspecular - the percentage of specular light reflected by the sphere\nroughness - the modeled roughness of the sphere, which affects the spread of the specular light across the object.", comment: "Sphere finish description")
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.endEditing(false)
        tableView.beginUpdates()
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "UnwindToSpheresTableViewController" else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let destination = segue.destination as! SpheresTableViewController
        if let selectedIndexPath = destination.tableView.indexPathForSelectedRow {
            destination.spheres[selectedIndexPath.row] = self.sphere!
        } else {
            let context = appDelegate.persistentContainer.viewContext

            var center = Point.zero
            var radius = 0.0
            var color = Color.black
            var finish = Finish.none
            let section = 0
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section))
                switch cell {
                case let cell as PointTableViewCell:
                    center = cell.point
                case let cell as SingleValueTableViewCell:
                    radius = cell.value
                case let cell as ColorTableViewCell:
                    color = cell.color
                case let cell as FinishTableViewCell:
                    finish = cell.finish
                default:
                    break
                }
            }
            destination.spheres.append(Sphere(center: center, radius: radius, color: color, finish: finish, context: context))
        }

        destination.tableView.reloadData()
        appDelegate.saveContext()
    }

}

extension AddEditSphereTableViewController: PointTableViewCellDelegate {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell) {
        if let sphere = self.sphere {
            sphere.center = cell.point
        }
    }
}

extension AddEditSphereTableViewController: SingleValueTableViewCellDelegate {
    func singleValueTableViewCellValueDidChange(_ cell: SingleValueTableViewCell) {
        if let sphere = self.sphere {
            sphere.radius = cell.value
        }
    }
}

extension AddEditSphereTableViewController: ColorTableViewCellDelegate {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell) {
        if let sphere = self.sphere {
            sphere.color = cell.color
        }
    }
}

extension AddEditSphereTableViewController: FinishTableViewCellDelegate {
    func finishTableViewCellFinishDidChange(_ cell: FinishTableViewCell) {
        if let sphere = self.sphere {
            sphere.finish = cell.finish
        }
    }
}
