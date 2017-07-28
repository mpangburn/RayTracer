//
//  AddEditSphereTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/8/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData


final class AddEditSphereTableViewController: ExpandableCellTableViewController {

    var sphere: Sphere {
        get {
            let context = PersistenceManager.shared.persistentContainer.viewContext
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
        tableView.register(SingleButtonTableViewCell.nib(), forCellReuseIdentifier: SingleButtonTableViewCell.className)

        tableView.estimatedRowHeight = 144
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.endEditing(true)
    }

    private enum Section: Int {
        case attributes
        case randomButton

        static let count = 2
    }

    private enum AttributeRow: Int {
        case center
        case radius
        case color
        case finish

        static let count = 4
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .attributes:
            return AttributeRow.count
        case .randomButton:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .attributes:
            switch AttributeRow(rawValue: indexPath.row)! {
            case .center:
                let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className, for: indexPath) as! PointTableViewCell
                cell.point = self.center
                cell.delegate = self
                return cell
            case .radius:
                let cell = tableView.dequeueReusableCell(withIdentifier: SingleValueTableViewCell.className, for: indexPath) as! SingleValueTableViewCell
                cell.label.text = NSLocalizedString("Radius", comment: "The title of the cell for configuring sphere radius")
                cell.value = self.radius
                cell.delegate = self
                return cell
            case .color:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className, for: indexPath) as! ColorTableViewCell
                cell.color = self.color
                cell.delegate = self
                return cell
            case .finish:
                let cell = tableView.dequeueReusableCell(withIdentifier: FinishTableViewCell.className, for: indexPath) as! FinishTableViewCell
                cell.finish = self.finish
                cell.delegate = self
                return cell
            }
        case .randomButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.className, for: indexPath) as! SingleButtonTableViewCell
            cell.button.setTitle(NSLocalizedString("Random Sphere", comment: "The button text for the random sphere button"), for: .normal)
            cell.button.addTarget(self, action: #selector(generateRandomSphere(_:)), for: .touchUpInside)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .attributes:
            return NSLocalizedString("ATTRIBUTES", comment: "The title of the section for sphere attribute editing")
        case .randomButton:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .attributes:
            return NSLocalizedString("The sphere's finish consists of four components. Ambient, diffuse, and specular refer to the percentages of respective light reflected by the finish. Roughness is the modeled roughness of the sphere, which affects the spread of specular light across the surface.", comment: "The description of a sphere's finish")
        case .randomButton:
            return NSLocalizedString("Attempts to generate a sphere visible in the scene frame.", comment: "The description for the effect of the random sphere button")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if Section(rawValue: indexPath.section) == .attributes && AttributeRow(rawValue: indexPath.row) != .radius {
            endRadiusEditing()
        }
    }

    private func endRadiusEditing() {
        let radiusCell = tableView.cellForRow(at: IndexPath(row: AttributeRow.radius.rawValue, section: Section.attributes.rawValue)) as! SingleValueTableViewCell
        radiusCell.valueTextField.resignFirstResponder()
    }

    // MARK: - Actions

    // How can this better accommodate eye points with different x and y values?
    @objc private func generateRandomSphere(_ button: UIButton) {
        let tracer = RayTracer.shared
        let sceneFrame = tracer.settings.sceneFrame
        let eyePoint = tracer.settings.eyePoint

        // Generate a random z coordinate for the center between the eye point and the existing sphere z coordinate closest to it
        let maxPossibleZ = 100.0
        let minPossibleZ = -100.0
        let buffer = 1.0 / 20.0
        let minZ: Double
        let maxZ: Double
        if eyePoint.z < 0 {
            minZ = ceil(eyePoint.z - buffer * eyePoint.z)
            let visibleSpheresZCoordinates = tracer.spheres
                .map { $0.center.z }
                .filter { $0 > minZ }
            maxZ = visibleSpheresZCoordinates.min() ?? maxPossibleZ
        } else {
            maxZ = eyePoint.z - buffer * eyePoint.z
            let visibleSpheresZCoordinates = tracer.spheres
                .map { $0.center.z }
                .filter { $0 < maxZ }
            minZ = visibleSpheresZCoordinates.max() ?? minPossibleZ
        }
        let z = (Int(minZ)...Int(maxZ)).random(decimalPlaces: 1)

        // Generate random x and y coordinates within the scene view and scale them based on z distance to the eye point
        let baseX = (Int(sceneFrame.minX)...Int(sceneFrame.maxX)).random(decimalPlaces: 1)
        let baseY = (Int(sceneFrame.minY)...Int(sceneFrame.maxY)).random(decimalPlaces: 1)
        let zDistanceScaleFactor = abs(eyePoint.z) / abs(eyePoint.z - z)
        let possibleXorYRange = -100.0...100.0
        let x = (baseX / zDistanceScaleFactor).roundedTo(decimalPlaces: 1).clamped(to: possibleXorYRange)
        let y = (baseY / zDistanceScaleFactor).roundedTo(decimalPlaces: 1).clamped(to: possibleXorYRange)
        self.center = Point(x: x, y: y, z: z)

        // Generate a random radius and scale it based on the center's distance to the eye point
        let maxBaseRadius = Int(min(sceneFrame.maxX - sceneFrame.minX, sceneFrame.maxY - sceneFrame.minY))
        let baseRadius = Double((1...maxBaseRadius).random())
        let halfVisibleDistance = (abs(eyePoint.z) + maxPossibleZ) / 2
        let centerToEyePointDistance = self.center.distance(from: eyePoint)
        self.radius = (baseRadius / (halfVisibleDistance / centerToEyePointDistance)).roundedTo(decimalPlaces: 2)

        // Generate a random color and finish
        self.color = Color.random()
        self.finish = Finish.random()
        
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        endRadiusEditing()
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
    func singleValueTableViewCellDidBeginEditing(_ cell: SingleValueTableViewCell) {
        tableView.beginUpdates()
        closeExpandableTableViewCells()
        tableView.endUpdates()
    }

    func singleValueTableViewCellValueDidChange(_ cell: SingleValueTableViewCell) {
        self.radius = cell.value
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

