//
//  AboutTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/27/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


private let aboutCellReuseIdentifier = "AboutCell"

final class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: aboutCellReuseIdentifier)
    }

    enum Row: Int {
        case howItWorks
        case tipsAndTricks
        case frequentlyAskedQuestions

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
        let cell = tableView.dequeueReusableCell(withIdentifier: aboutCellReuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator

        switch Row(rawValue: indexPath.row)! {
        case .howItWorks:
            cell.textLabel?.text = NSLocalizedString("How It Works", comment: "The title text for the cell describing how ray tracing works")
        case .tipsAndTricks:
            cell.textLabel?.text = NSLocalizedString("Tips and Tricks", comment: "The title text for the cell describing tips and tricks for using the application")
        case .frequentlyAskedQuestions:
            cell.textLabel?.text = NSLocalizedString("Frequently Asked Questions (FAQs)", comment: "The title text the cell describing frequently asked questions in using the application")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sender = tableView.cellForRow(at: indexPath)

        switch Row(rawValue: indexPath.row)! {
        case .howItWorks:
            self.show(HowItWorksTableViewController(), sender: sender)
        case .tipsAndTricks:
            self.show(TipsAndTricksTableViewController(), sender: sender)
        case .frequentlyAskedQuestions:
            self.show(FrequentlyAskedQuestionsTableViewController(), sender: sender)
        }
    }
}
