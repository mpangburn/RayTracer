//
//  AddEditSphereTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit

class AddEditSphereTableViewController: UITableViewController {

    var sphere: Sphere?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PointTableViewCell.nib(), forCellReuseIdentifier: PointTableViewCell.className)
        tableView.register(SingleValueTableViewCell.nib(), forCellReuseIdentifier: SingleValueTableViewCell.className)
        tableView.register(ColorTableViewCell.nib(), forCellReuseIdentifier: ColorTableViewCell.className)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tableView.endEditing(true)
    }

    private enum Row: Int {
        case center
        case radius
        case color
        static let count = 3
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
            let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className, for: indexPath) as! PointTableViewCell
            cell.point = sphere?.center ?? Point.zero
            return cell
        case .radius:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleValueTableViewCell.className) as! SingleValueTableViewCell
            cell.label.text = "Radius"
            cell.value = sphere?.radius ?? 0
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className, for: indexPath) as! ColorTableViewCell
            cell.color = sphere?.color ?? Color.black
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "ATTRIBUTES" : ""
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

}
