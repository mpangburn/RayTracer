//
//  SettingsTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var eye: Point! {
        get {
            return UserDefaults.standard.eye ?? RayTracer.Defaults.eye
        }
        set {
            UserDefaults.standard.eye = newValue
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.eye.rawValue)) as! PointTableViewCell
            cell.point = eye
        }
    }

    var light: Light! {
        get {
            return UserDefaults.standard.light ?? RayTracer.Defaults.light
        }
        set {
            UserDefaults.standard.light = newValue
            let positionCell = tableView.cellForRow(at: IndexPath(row: LightRow.position.rawValue, section: Section.light.rawValue)) as! PointTableViewCell
            positionCell.point = light.position
            let colorCell = tableView.cellForRow(at: IndexPath(row: LightRow.color.rawValue, section: Section.light.rawValue)) as! ColorTableViewCell
            colorCell.color = light.color
        }
    }

    var ambient: Color! {
        get {
            return UserDefaults.standard.ambient ?? RayTracer.Defaults.ambient
        }
        set {
            UserDefaults.standard.ambient = newValue
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: Section.ambient.rawValue)) as! ColorTableViewCell
            cell.color = ambient
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Settings", comment: "The title text for the settings screen")

        tableView.register(PointTableViewCell.nib(), forCellReuseIdentifier: PointTableViewCell.className)
        tableView.register(ColorTableViewCell.nib(), forCellReuseIdentifier: ColorTableViewCell.className)
        tableView.register(SingleButtonTableViewCell.nib(), forCellReuseIdentifier: SingleButtonTableViewCell.className)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tableView.endEditing(true)
    }

    private enum Section: Int {
        case eye
        case light
        case ambient
        case reset

        static let count = 4
    }

    private enum LightRow: Int {
        case position
        case color
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .eye:
            return NSLocalizedString("EYE", comment: "The title of the section for the scene's eye setting")
        case .light:
            return NSLocalizedString("LIGHT", comment: "The title of the section for the scene's light setting")
        case .ambient:
            return NSLocalizedString("AMBIENT", comment: "The title of the section for the scene's ambient color setting")
        case .reset:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .eye:
            return 1
        case .light:
            return 2
        case .ambient:
            return 1
        case .reset:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .eye:
            let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className) as! PointTableViewCell
            cell.point = self.eye
            cell.pointType = .eye
            cell.delegate = self
            return cell
        case .light:
            switch LightRow(rawValue: indexPath.row)! {
            case .position:
                let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className) as! PointTableViewCell
                cell.point = self.light.position
                cell.pointType = .light
                cell.delegate = self
                return cell
            case .color:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
                cell.color = self.light.color
                cell.colorType = .light
                cell.delegate = self
                return cell
            }
        case .ambient:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
            cell.color = self.ambient
            cell.colorType = .ambient
            cell.delegate = self
            return cell
        case .reset:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.className) as! SingleButtonTableViewCell
            cell.button.setTitle(NSLocalizedString("Reset", comment: "The title text for the reset button"), for: .normal)
            cell.button.setTitleColor(.red, for: .normal)
            cell.button.addTarget(self, action: #selector(SettingsTableViewController.resetButtonPressed(_:)), for: .touchUpInside)
            return cell
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

    @objc private func resetButtonPressed(_ button: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Reset Settings", comment: "The title text for the reset alert"),
                                                message: NSLocalizedString("Are you sure you want to reset ray tracing settings? This will not affect sphere data.", comment: "The subtitle text for the reset alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: "The text for the reset button within the reset alert"), style: .destructive) { _ in
            self.eye = nil
            self.light = nil
            self.ambient = nil
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "The text for the cancel button within the reset alert"), style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension SettingsTableViewController: PointTableViewCellDelegate {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell) {
        switch cell.pointType! {
        case .eye:
            UserDefaults.standard.eye = cell.point
        case .light:
            UserDefaults.standard.light = Light(position: cell.point, color: self.light.color)
        }
    }
}

extension SettingsTableViewController: ColorTableViewCellDelegate {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell) {
        switch cell.colorType! {
        case .light:
            UserDefaults.standard.light = Light(position: self.light.position, color: cell.color)
        case .ambient:
            UserDefaults.standard.ambient = cell.color
        }
    }
}
