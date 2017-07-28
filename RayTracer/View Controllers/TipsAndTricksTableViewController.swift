//
//  TipsAndTricksTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/27/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


final class TipsAndTricksTableViewController: InformationTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Tips and Tricks", comment: "The title text for the screen displaying tips and tricks for ray tracing")
    }

    enum Section: Int {
        case spheres
        case eyePointAndFrame

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
        case .spheres:
            cell.textLabel?.text = ""
        case .eyePointAndFrame:
            cell.textLabel?.text = ""
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .spheres:
            return NSLocalizedString("SPHERES", comment: "The title text for the tips and tricks section regarding spheres")
        case .eyePointAndFrame:
            return NSLocalizedString("EYE POINT & FRAME", comment: "The title text for the tips and tricks section regarding eye point and frame")
        }
    }
}
