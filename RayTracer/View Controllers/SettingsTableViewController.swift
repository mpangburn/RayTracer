//
//  SettingsTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData


final class SettingsTableViewController: ExpandableCellTableViewController {

    let tracer = RayTracer.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Settings", comment: "The title text for the settings screen")

        tableView.register(PointTableViewCell.nib(), forCellReuseIdentifier: PointTableViewCell.className)
        tableView.register(ColorTableViewCell.nib(), forCellReuseIdentifier: ColorTableViewCell.className)
        tableView.register(SegmentedControlTableViewCell.nib(), forCellReuseIdentifier: SegmentedControlTableViewCell.className)
        tableView.register(FrameViewTableViewCell.nib(), forCellReuseIdentifier: FrameViewTableViewCell.className)
        tableView.register(FrameSizeTableViewCell.nib(), forCellReuseIdentifier: FrameSizeTableViewCell.className)
        tableView.register(SingleButtonTableViewCell.nib(), forCellReuseIdentifier: SingleButtonTableViewCell.className)

        tableView.estimatedRowHeight = 144
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.rayTracerSettings = tracer.settings
    }

    fileprivate enum Section: Int {
        case eyePoint
        case light
        case ambience
        case background
        case frame
        case resetSettings
        case resetSpheres

        static let count = 7
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
        case .resetSettings, .resetSpheres:
            return nil
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
            let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className, for: indexPath) as! PointTableViewCell
            cell.point = tracer.settings.eyePoint
            cell.delegate = self
            return cell
        case .light:
            switch LightRow(rawValue: indexPath.row)! {
            case .position:
                let cell = tableView.dequeueReusableCell(withIdentifier: PointTableViewCell.className, for: indexPath) as! PointTableViewCell
                cell.point = tracer.settings.light.position
                cell.delegate = self
                return cell
            case .color:
                let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className, for: indexPath) as! ColorTableViewCell
                cell.color = tracer.settings.light.color
                cell.delegate = self
                return cell
            case .intensity:
                let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.className, for: indexPath) as! SegmentedControlTableViewCell
                cell.valueType = .intensity
                cell.intensity = tracer.settings.light.intensity
                cell.delegate = self
                return cell
            }
        case .ambience:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className, for: indexPath) as! ColorTableViewCell
            cell.color = tracer.settings.ambience
            cell.delegate = self
            return cell
        case .background:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColorTableViewCell.className, for: indexPath) as! ColorTableViewCell
            cell.color = tracer.settings.backgroundColor
            cell.delegate = self
            return cell
        case .frame:
            switch FrameRow(rawValue: indexPath.row)! {
            case .view:
                let cell = tableView.dequeueReusableCell(withIdentifier: FrameViewTableViewCell.className, for: indexPath) as! FrameViewTableViewCell
                let frame = tracer.settings.sceneFrame
                cell.minX = frame.minX
                cell.maxX = frame.maxX
                cell.minY = frame.minY
                cell.maxY = frame.maxY
                cell.zPlane = frame.zPlane
                cell.delegate = self
                return cell
            case .size:
                let cell = tableView.dequeueReusableCell(withIdentifier: FrameSizeTableViewCell.className, for: indexPath) as! FrameSizeTableViewCell
                cell.width = tracer.settings.sceneFrame.width
                cell.height = tracer.settings.sceneFrame.height
                cell.delegate = self
                return cell
            case .aspectRatio:
                let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedControlTableViewCell.className, for: indexPath) as! SegmentedControlTableViewCell
                cell.valueType = .aspectRatio
                cell.aspectRatio = tracer.settings.sceneFrame.aspectRatio
                cell.delegate = self
                return cell
            }
        case .resetSettings:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.className, for: indexPath) as! SingleButtonTableViewCell
            cell.button.setTitle(NSLocalizedString("Reset Settings", comment: "The title text for the reset settings button"), for: .normal)
            cell.button.setTitleColor(.red, for: .normal)
            cell.button.addTarget(self, action: #selector(resetSettingsButtonPressed(_:)), for: .touchUpInside)
            return cell
        case .resetSpheres:
            let cell = tableView.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.className, for: indexPath) as! SingleButtonTableViewCell
            cell.button.setTitle(NSLocalizedString("Reset Spheres", comment: "The title text for the reset spheres button"), for: .normal)
            cell.button.setTitleColor(.red, for: .normal)
            cell.button.addTarget(self, action: #selector(resetSpheresButtonPressed(_:)), for: .touchUpInside)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .background:
            return NSLocalizedString("The background color is used for space where no spheres appear in the scene. Shadows are not cast on the background.", comment: "The description for the scene's background color")
        case .frame:
            return NSLocalizedString("The minimum and maximum x and y values specify the bounds of the view rectangle rendered in the z-plane. The width and height specify the dimensions of the rendered image.", comment: "The description for the scene frame")
        default:
            return nil
        }
    }

    // MARK: - Actions

    @objc private func resetSettingsButtonPressed(_ button: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Reset Settings", comment: "The title text for the reset settings alert"),
                                                message: NSLocalizedString("Are you sure you want to reset ray tracing settings? This will not affect sphere data.", comment: "The subtitle text for the reset alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: "The text for the reset button within the reset settings alert"), style: .destructive) { _ in
            self.tracer.settings = RayTracerSettings()
            self.tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "The text for the cancel button within the reset settings alert"), style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }

    @objc private func resetSpheresButtonPressed(_ button: UIButton) {
        let alertController = UIAlertController(title: NSLocalizedString("Reset Spheres", comment: "The title text for the reset spheres alert"),
                                                message: NSLocalizedString("Are you sure you want to reset sphere data?", comment: "The subtitle text for the reset spheres alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Reset", comment: "The text for the reset button within the reset spheres alert"), style: .destructive) { _ in
            let context = PersistenceManager.shared.persistentContainer.viewContext
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: Sphere.fetchRequest())
            let _ = try? context.execute(deleteRequest)
            let tracer = RayTracer.shared
            tracer.spheres.removeAll()
            tracer.spheres.append(Sphere(string: "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05", context: context)!)
            tracer.spheres.append(Sphere(string: "8.0 -10.0 100.0 90.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05", context: context)!)
            NotificationCenter.default.post(name: .SphereDataDidReset, object: nil)
            PersistenceManager.shared.saveContext()
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "The text for the cancel button within the reset spheres alert"), style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}

extension SettingsTableViewController: PointTableViewCellDelegate {
    func pointTableViewCellPointDidChange(_ cell: PointTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        switch Section(rawValue: indexPath.section)! {
        case .eyePoint:
            tracer.settings.eyePoint = cell.point
        case .light:
            tracer.settings.light.position = cell.point
        default:
            break
        }
    }
}

extension SettingsTableViewController: ColorTableViewCellDelegate {
    func colorTableViewCellColorDidChange(_ cell: ColorTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        switch Section(rawValue: indexPath.section)! {
        case .light:
            tracer.settings.light.color = cell.color
        case .ambience:
            tracer.settings.ambience = cell.color
        case .background:
            tracer.settings.backgroundColor = cell.color
        default:
            break
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

            let frameViewCell = tableView.cellForRow(at: IndexPath(row: FrameRow.view.rawValue, section: Section.frame.rawValue)) as! FrameViewTableViewCell
            let maxMinYSliderValue = Double(frameViewCell.minYSlider.maximumValue)
            if frameViewCell.minY == maxMinYSliderValue || tracer.settings.sceneFrame.minY > maxMinYSliderValue {
                tracer.settings.sceneFrame.minY = maxMinYSliderValue
            }

            frameViewCell.minX = tracer.settings.sceneFrame.minX
            frameViewCell.maxX = tracer.settings.sceneFrame.maxX
            frameViewCell.minY = tracer.settings.sceneFrame.minY
            frameViewCell.maxY = tracer.settings.sceneFrame.maxY

            let frameSizeCell = tableView.cellForRow(at: IndexPath(row: FrameRow.size.rawValue, section: Section.frame.rawValue)) as! FrameSizeTableViewCell
            let minHeightSliderValue = Int(frameSizeCell.heightSlider.minimumValue)
            if frameSizeCell.height == minHeightSliderValue || tracer.settings.sceneFrame.height < minHeightSliderValue {
                tracer.settings.sceneFrame.height = minHeightSliderValue
            }

            frameSizeCell.width = tracer.settings.sceneFrame.width
            frameSizeCell.height = tracer.settings.sceneFrame.height
        }
    }
}

extension SettingsTableViewController: FrameViewTableViewCellDelegate {
    func frameViewTableViewCellMinXDidChange(_ cell: FrameViewTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.minX = cell.minX
            return
        }

        let maxMinYSliderValue = Double(cell.minYSlider.maximumValue)
        let minYIsAtMaxAndMinXIsIncreasing = cell.minY == maxMinYSliderValue && cell.minX > tracer.settings.sceneFrame.minX
        let minXSliderValueWasIncreasedQuickly = tracer.settings.sceneFrame.minY > maxMinYSliderValue && cell.minX == Double(cell.minXSlider.maximumValue)
        if minYIsAtMaxAndMinXIsIncreasing || minXSliderValueWasIncreasedQuickly {
            tracer.settings.sceneFrame.minY = maxMinYSliderValue
        } else {
            tracer.settings.sceneFrame.minX = cell.minX
            cell.minY = tracer.settings.sceneFrame.minY
            cell.maxY = tracer.settings.sceneFrame.maxY
        }

        cell.minX = tracer.settings.sceneFrame.minX
        cell.maxX = tracer.settings.sceneFrame.maxX
    }

    func frameViewTableViewCellMaxXDidChange(_ cell: FrameViewTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.maxX = cell.maxX
            return
        }

        let maxMinYSliderValue = Double(cell.minYSlider.maximumValue)
        let minYIsAtMaxAndMaxXIsDecreasing = cell.minY == maxMinYSliderValue && cell.maxX < tracer.settings.sceneFrame.maxX
        let maxXSliderValueWasDecreasedQuickly = tracer.settings.sceneFrame.minY > maxMinYSliderValue && cell.maxX == Double(cell.maxXSlider.minimumValue)
        if minYIsAtMaxAndMaxXIsDecreasing || maxXSliderValueWasDecreasedQuickly {
            tracer.settings.sceneFrame.minY = maxMinYSliderValue
        } else {
            tracer.settings.sceneFrame.maxX = cell.maxX
            cell.minY = tracer.settings.sceneFrame.minY
            cell.maxY = tracer.settings.sceneFrame.maxY
        }

        cell.minX = tracer.settings.sceneFrame.minX
        cell.maxX = tracer.settings.sceneFrame.maxX
    }

    func frameViewTableViewCellMinYDidChange(_ cell: FrameViewTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.minY = cell.minY
            return
        }

        let minMinXSliderValue = Double(cell.minXSlider.minimumValue)
        let minXIsAtMinAndMinYIsDecreasing = cell.minX == minMinXSliderValue && cell.minY < tracer.settings.sceneFrame.minY
        if minXIsAtMinAndMinYIsDecreasing {
            tracer.settings.sceneFrame.minX = minMinXSliderValue
        } else {
            tracer.settings.sceneFrame.minY = cell.minY
            cell.minX = tracer.settings.sceneFrame.minX
            cell.maxX = tracer.settings.sceneFrame.maxX
        }

        cell.minY = tracer.settings.sceneFrame.minY
        cell.maxY = tracer.settings.sceneFrame.maxY
    }

    func frameViewTableViewCellMaxYDidChange(_ cell: FrameViewTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.maxY = cell.maxY
            return
        }

        let minMinXSliderValue = Double(cell.minXSlider.minimumValue)
        let minXIsAtMinAndMaxYIsIncreasing = cell.minX == minMinXSliderValue && cell.maxY > tracer.settings.sceneFrame.maxY
        if minXIsAtMinAndMaxYIsIncreasing {
            tracer.settings.sceneFrame.minX = minMinXSliderValue
        } else {
            tracer.settings.sceneFrame.maxY = cell.maxY
            cell.minX = tracer.settings.sceneFrame.minX
            cell.maxX = tracer.settings.sceneFrame.maxX
        }

        cell.minY = tracer.settings.sceneFrame.minY
        cell.maxY = tracer.settings.sceneFrame.maxY
    }

    func frameViewTableViewCellZPlaneDidChange(_ cell: FrameViewTableViewCell) {
        tracer.settings.sceneFrame.zPlane = cell.zPlane
    }
}

extension SettingsTableViewController: FrameSizeTableViewCellDelegate {
    func frameSizeTableViewCellWidthDidChange(_ cell: FrameSizeTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.width = cell.width
            return
        }

        let minHeightSliderValue = Int(cell.heightSlider.minimumValue)
        let heightIsAtMinAndWidthIsDecreasing = cell.height == minHeightSliderValue && cell.width < tracer.settings.sceneFrame.width
        let widthSliderValueWasDecreasedQuickly = tracer.settings.sceneFrame.height < minHeightSliderValue && cell.width == Int(cell.widthSlider.minimumValue)
        if heightIsAtMinAndWidthIsDecreasing || widthSliderValueWasDecreasedQuickly {
            tracer.settings.sceneFrame.height = minHeightSliderValue
        } else {
            tracer.settings.sceneFrame.width = cell.width
            cell.height = tracer.settings.sceneFrame.height
        }

        cell.width = tracer.settings.sceneFrame.width
    }

    func frameSizeTableViewCellHeightDidChange(_ cell: FrameSizeTableViewCell) {
        guard tracer.settings.sceneFrame.aspectRatio != .freeform else {
            tracer.settings.sceneFrame.height = cell.height
            return
        }

        let maxWidthSliderValue = Int(cell.widthSlider.maximumValue)
        let widthIsAtMaxAndHeightIsIncreasing = cell.width == maxWidthSliderValue && cell.height > tracer.settings.sceneFrame.height
        if widthIsAtMaxAndHeightIsIncreasing {
            tracer.settings.sceneFrame.width = maxWidthSliderValue
        } else {
            tracer.settings.sceneFrame.height = cell.height
            cell.width = tracer.settings.sceneFrame.width
        }

        cell.height = tracer.settings.sceneFrame.height
    }
}
