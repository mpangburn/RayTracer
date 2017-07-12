//
//  AddEditSphereTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData

class AddEditSphereTableViewController: UITableViewController, ExpandableTableViewCellDelegate {

    var sphere: Sphere {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Failed to access AppDelegate")
            }
            let context = appDelegate.persistentContainer.viewContext
            return Sphere(center: self.center, radius: self.radius, color: self.color, finish: self.finish, context: context)
        }
        set {
            self.center = newValue.center
            self.radius = newValue.radius
            self.color = newValue.color
            self.finish = newValue.finish
        }
    }

    var center = Point.zero
    var radius = 0.0
    var color = Color.black
    var finish = Finish.none

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
            cell.point = self.center
            cell.delegate = self
            return cell
        case .radius:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleValueTableViewCell.className) as! SingleValueTableViewCell
            cell.label.text = NSLocalizedString("Radius", comment: "The title of the cell for configuring sphere radius")
            cell.value = self.radius
            cell.delegate = self
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
            cell.color = self.color
            cell.delegate = self
            return cell
        case .finish:
            let cell = tableView.dequeueReusableCell(withIdentifier: FinishTableViewCell.className) as! FinishTableViewCell
            cell.finish = self.finish
            cell.delegate = self
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? NSLocalizedString("ATTRIBUTES", comment: "The title of the section for sphere attribute editing") : ""
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Ambient, diffuse, and specular refer to the percentages of respective light reflected by the sphere's finish. Roughness is the modeled roughness of the sphere, which affects the spread of specular light across the surface.", comment: "Sphere finish description")
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
        closeExpandableTableViewCells(excluding: indexPath)
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let radiusCell = tableView.cellForRow(at: IndexPath(row: Row.radius.rawValue, section: 0)) as! SingleValueTableViewCell
        radiusCell.endTextFieldEditing()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UITabBarController {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
}

extension AddEditSphereTableViewController: PointTableViewCellDelegate {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell) {
        self.center = cell.point
    }
}

extension AddEditSphereTableViewController: SingleValueTableViewCellDelegate {
    func singleValueTableViewCellValueDidChange(_ cell: SingleValueTableViewCell) {
        self.radius = cell.value
    }

    func singleValueTableViewCellDidBeginEditing(_ cell: SingleValueTableViewCell) {
        tableView.beginUpdates()
        closeExpandableTableViewCells()
        tableView.endUpdates()
    }
}

extension AddEditSphereTableViewController: ColorTableViewCellDelegate {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell) {
        self.color = cell.color
    }
}

extension AddEditSphereTableViewController: FinishTableViewCellDelegate {
    func finishTableViewCellFinishDidChange(_ cell: FinishTableViewCell) {
        self.finish = cell.finish
    }
}

