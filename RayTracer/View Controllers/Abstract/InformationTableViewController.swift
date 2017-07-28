//
//  InformationTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/27/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit



class InformationTableViewController: UITableViewController {

    let basicCellReuseIdentifier = "BasicCell"

    convenience init() {
        self.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: basicCellReuseIdentifier)
        tableView.estimatedRowHeight = 144
        tableView.allowsSelection = false
    }
}
