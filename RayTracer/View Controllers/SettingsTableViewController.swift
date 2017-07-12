//
//  SettingsTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, ExpandableTableViewCellDelegate {

    var tracer = RayTracer.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Settings", comment: "The title text for the settings screen")

        tableView.register(PointTableViewCell.nib(), forCellReuseIdentifier: PointTableViewCell.className)
        tableView.register(ColorTableViewCell.nib(), forCellReuseIdentifier: ColorTableViewCell.className)
        tableView.register(IntensityTableViewCell.nib(), forCellReuseIdentifier: IntensityTableViewCell.className)
        tableView.register(FrameViewTableViewCell.nib(), forCellReuseIdentifier: FrameViewTableViewCell.className)
        tableView.register(FrameSizeTableViewCell.nib(), forCellReuseIdentifier: FrameSizeTableViewCell.className)
        tableView.register(SingleButtonTableViewCell.nib(), forCellReuseIdentifier: SingleButtonTableViewCell.className)
    }

    override func viewWillDisappear(_ animated: Bool) {
        tableView.endEditing(true)
    }

    private enum Section: Int {
        case eyePoint
        case light
        case ambience
        case frame
        case resetButton

        static let count = 5
    }

    private enum LightRow: Int {
        case position
        case color
        case intensity

        static let count = 3
    }

    private enum FrameRow: Int {
        case view
        case size

        static let count = 2
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .eyePoint:
            return NSLocalizedString("EYE POINT", comment: "The title of the section for the scene's viewpoint setting")
        case .light:
            return NSLocalizedString("LIGHT", comment: "The title of the section for the scene's light setting")
        case .ambience:
            return NSLocalizedString("AMBIENCE", comment: "The title of the section for the scene's ambient color setting")
        case .frame:
            return NSLocalizedString("FRAME", comment: "The title of the section for the scene's frame setting")
        case .resetButton:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .light:
            return LightRow.count
        case .frame:
            return FrameRow.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .eyePoint:
            let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className) as! PointTableViewCell
            cell.point = tracer.settings.eyePoint
            cell.pointType = .eye
            cell.delegate = self
            return cell
        case .light:
            switch LightRow(rawValue: indexPath.row)! {
            case .position:
                let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className) as! PointTableViewCell
                cell.point = tracer.settings.light.position
                cell.pointType = .light
                cell.delegate = self
                return cell
            case .color:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
                cell.color = tracer.settings.light.color
                cell.colorType = .light
                cell.delegate = self
                return cell
            case .intensity:
                let cell = tableView.dequeueReusableCell(withIdentifier: IntensityTableViewCell.className) as! IntensityTableViewCell
                cell.intensity = tracer.settings.light.intensity
                cell.delegate = self
                return cell
            }
        case .ambience:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
            cell.color = tracer.settings.ambience
            cell.colorType = .ambience
            cell.delegate = self
            return cell
        case .frame:
            switch FrameRow(rawValue: indexPath.row)! {
            case .view:
                let cell = tableView.dequeueReusableCell(withIdentifier: FrameViewTableViewCell.className) as! FrameViewTableViewCell
                cell.frameView = tracer.settings.sceneFrame.view
                cell.delegate = self
                return cell
            case .size:
                let cell = tableView.dequeueReusableCell(withIdentifier: FrameSizeTableViewCell.className) as! FrameSizeTableViewCell
                cell.frameSize = tracer.settings.sceneFrame.size
                cell.delegate = self
                return cell
            }
        case .resetButton:
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

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .frame:
            return NSLocalizedString("The minimum and maximum x and y values specify the bounds of the view rectangle rendered in the z-plane. The width and height specify the dimensions of the rendered image.", comment: "The description for the scene frame")
        default:
            return nil
        }
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
//        if Section(rawValue: indexPath.section) != .resetButton {
//            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
    }


    // MARK: - Actions

    @objc private func resetButtonPressed(_ button: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Reset Settings", comment: "The title text for the reset alert"),
                                                message: NSLocalizedString("Are you sure you want to reset ray tracing settings? This will not affect sphere data.", comment: "The subtitle text for the reset alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: "The text for the reset button within the reset alert"), style: .destructive) { _ in
            self.tracer.settings = RayTracerSettings()
            self.tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "The text for the cancel button within the reset alert"), style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension SettingsTableViewController: PointTableViewCellDelegate {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell) {
        switch cell.pointType! {
        case .eye:
            tracer.settings.eyePoint = cell.point
        case .light:
            tracer.settings.light.position = cell.point
        }
    }
}

extension SettingsTableViewController: ColorTableViewCellDelegate {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell) {
        switch cell.colorType! {
        case .light:
            tracer.settings.light.color = cell.color
        case .ambience:
            tracer.settings.ambience = cell.color
        }
    }
}

extension SettingsTableViewController: IntensityTableViewCellDelegate {
    func intensityTableViewCellIntensityDidChange(_ cell: IntensityTableViewCell) {
        tracer.settings.light.intensity = cell.intensity
    }
}

extension SettingsTableViewController: FrameViewTableViewCellDelegate {
    func frameViewTableViewCellFrameViewDidChange(_ cell: FrameViewTableViewCell) {
        tracer.settings.sceneFrame.view = cell.frameView
    }
}

extension SettingsTableViewController: FrameSizeTableViewCellDelegate {
    func frameSizeTableViewCellFrameSizeDidChange(_ cell: FrameSizeTableViewCell) {
        tracer.settings.sceneFrame.size = cell.frameSize
    }
}
