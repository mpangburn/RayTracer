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
        tableView.register(SegmentedControlTableViewCell.nib(), forCellReuseIdentifier: SegmentedControlTableViewCell.className)
        tableView.register(FrameViewTableViewCell.nib(), forCellReuseIdentifier: FrameViewTableViewCell.className)
        tableView.register(FrameSizeTableViewCell.nib(), forCellReuseIdentifier: FrameSizeTableViewCell.className)
        tableView.register(SingleButtonTableViewCell.nib(), forCellReuseIdentifier: SingleButtonTableViewCell.className)
    }

    fileprivate enum Section: Int {
        case eyePoint
        case light
        case ambience
        case background
        case frame
        case resetButton

        static let count = 6
    }

    private enum LightRow: Int {
        case position
        case color
        case intensity

        static let count = 3
    }

    fileprivate enum FrameRow: Int {
        case view
        case size
        case aspectRatio

        static let count = 3
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
        case .background:
            return NSLocalizedString("BACKGROUND", comment: "The title of the section for the scene's background color setting")
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
                let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.className) as! SegmentedControlTableViewCell
                cell.valueType = .intensity
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
        case .background:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className) as! ColorTableViewCell
            cell.color = tracer.settings.backgroundColor
            cell.colorType = .background
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
                cell.width = tracer.settings.sceneFrame.width
                cell.height = tracer.settings.sceneFrame.height
                cell.delegate = self
                return cell
            case .aspectRatio:
                let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.className) as! SegmentedControlTableViewCell
                cell.valueType = .aspectRatio
                cell.aspectRatio = tracer.settings.sceneFrame.aspectRatio
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
        case .background:
            return NSLocalizedString("The background color is used for space where no spheres exist. Shadows are not cast on the background.", comment: "The description for the scene's background color")
        case .frame:
            return NSLocalizedString("The minimum and maximum x and y values specify the bounds of the view rectangle rendered in the z-plane. The width and height specify the dimensions of the rendered image.", comment: "The description for the scene frame")
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.beginUpdates()
        closeExpandableTableViewCells(excluding: indexPath)
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
//        if let _ = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell {
//            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
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
        case .background:
            tracer.settings.backgroundColor = cell.color
        }
    }
}

extension SettingsTableViewController: SegmentedControlTableViewCellDelegate {
    func segmentedControlTableViewCellSegmentedControlValueDidChange(_ cell: SegmentedControlTableViewCell) {
        switch cell.valueType {
        case .intensity:
            tracer.settings.light.intensity = cell.intensity!
        case .aspectRatio:
            tracer.settings.sceneFrame.aspectRatio = cell.aspectRatio!
            let sizeCell = tableView.cellForRow(at: IndexPath(row: FrameRow.size.rawValue, section: Section.frame.rawValue)) as! FrameSizeTableViewCell
            sizeCell.width = tracer.settings.sceneFrame.width
            sizeCell.height = tracer.settings.sceneFrame.height
            print(tracer.settings.sceneFrame)
        }
    }
}

extension SettingsTableViewController: FrameViewTableViewCellDelegate {
    func frameViewTableViewCellFrameViewDidChange(_ cell: FrameViewTableViewCell) {
        tracer.settings.sceneFrame.view = cell.frameView
    }
}

extension SettingsTableViewController: FrameSizeTableViewCellDelegate {
    func frameSizeTableViewCellFrameSizeDidChange(_ cell: FrameSizeTableViewCell) {
        tracer.settings.sceneFrame.width = cell.width
        tracer.settings.sceneFrame.height = cell.height

//        let maxWidthSliderValue = Int(cell.widthSlider.maximumValue)
//        if tracer.settings.sceneFrame.width > maxWidthSliderValue {
//            tracer.settings.sceneFrame.width = maxWidthSliderValue
//        }
//
//        let maxHeightSliderValue = Int(cell.heightSlider.maximumValue)
//        if tracer.settings.sceneFrame.height > maxHeightSliderValue {
//            tracer.settings.sceneFrame.height = maxHeightSliderValue
//        }

        cell.width = tracer.settings.sceneFrame.width
        cell.height = tracer.settings.sceneFrame.height

        print(tracer.settings.sceneFrame)
    }
}
