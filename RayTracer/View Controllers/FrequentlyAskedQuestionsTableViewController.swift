//
//  FrequentlyAskedQuestionsTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/27/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


final class FrequentlyAskedQuestionsTableViewController: InformationTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("FAQs", comment: "The title text for the screen displaying frequently asked questions")
    }

    enum Section: Int {
        case longRenderingTime
        case invisibleSphere
        case blackSphere
        case skewedImage

        static let count = 4
    }

    enum Row: Int {
        case question
        case answer

        static let count = 2
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: basicCellReuseIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0

        let row = Row(rawValue: indexPath.row)!
        let calloutFont = UIFont.preferredFont(forTextStyle: .callout)
        var text: String
        switch row {
        case .question:
            let boldDescriptor = calloutFont.fontDescriptor.withSymbolicTraits(.traitBold)!
            let boldCalloutFont = UIFont(descriptor: boldDescriptor, size: 0)
            cell.textLabel?.font = boldCalloutFont
            text = "\(indexPath.section + 1). "
        case .answer:
            cell.textLabel?.font = calloutFont
            text = "• "
        }

        switch Section(rawValue: indexPath.section)! {
        case .longRenderingTime:
            switch row {
            case .question:
                text += NSLocalizedString("Why does my image take so long to render?", comment: "The text for the question regarding long rendering time")
            case .answer:
                text += NSLocalizedString("Pixel-by-pixel image rendering is a computationally intensive task. Reduce the size of the frame to improve rendering time.", comment: "The answer to the question regarding long rendering time")
            }
        case .invisibleSphere:
            switch row {
            case .question:
                text += NSLocalizedString("Why can't I see my sphere?", comment: "The text for the question regarding an invisible sphere")
            case .answer:
                text += NSLocalizedString("A sphere's visibility depends on its position and radius relative to the other spheres in addition to the scene's eye point and frame. See tips and tricks for suggestions on making your spheres visible in the scene.", comment: "The answer to the question regarding an invisible sphere")
            }
        case .blackSphere:
            switch row {
            case .question:
                text += NSLocalizedString("Why is my sphere black?", comment: "The text for the question regarding spheres appearing black")
            case .answer:
                text += NSLocalizedString("A sphere will appear black if the ambient component of its finish is zero, i.e. the sphere reflects no ambient light.", comment: "The answer to the question regarding spheres appearing black")
            }
        case .skewedImage:
            switch row {
            case .question:
                text += NSLocalizedString("Why does my image appear skewed?", comment: "The text for the question regarding image skew")
            case .answer:
                text += NSLocalizedString("See tips and tricks: eye point & frame", comment: "The answer to the question regarding image skew")
            }
        }

        cell.textLabel?.text = text
        
        return cell
    }
}
