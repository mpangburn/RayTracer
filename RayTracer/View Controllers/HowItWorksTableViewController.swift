//
//  HowItWorksTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/27/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


final class HowItWorksTableViewController: InformationTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("How It Works", comment: "The title text for the screen explaining how ray tracing works")
    }

    enum Section: Int {
        case rayTracing
        case randomSphereGeneration

        static let count = 2
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: basicCellReuseIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .callout)

        switch Section(rawValue: indexPath.section)! {
        case .rayTracing:
            cell.textLabel?.text = NSLocalizedString("Ray tracing pixel-by-pixel renders an image, taking into account the spheres present, these spheres' interactions with the scene's light and ambient color, the eye point from which the scene is viewed, and the frame dictating the visible coordinates. More advanced graphics processors also factor in light reflection off other objects.", comment: "The text describing how ray tracing works")
        case .randomSphereGeneration:
            cell.textLabel?.text = NSLocalizedString("In generating a random sphere visible in the scene, the center's z-coordinate is randomized within the bounds of the eye point and the existing (visible) sphere closest to the eyepoint. Its x- and y-coordinates are randomized within the scene frame's view, then scaled based on the distance between the eyepoint's z-coordinate and the randomly generated z-coordinate. The sphere's radius is randomized based on the range of visible x- and y-coordinates in the scene, then scaled based on the center's distance from the eyepoint. Finally, a random color and finish are generated.", comment: "The text describing how random sphere generation works")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .rayTracing:
            return NSLocalizedString("RAY TRACING", comment: "The title text for the section describing how ray tracing works")
        case .randomSphereGeneration:
            return NSLocalizedString("RANDOM SPHERE GENERATION", comment: "The title text for the section describing how random sphere generation works")
        }
    }
}
