//
//  ExpandableCellTableViewController.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/14/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


class ExpandableCellTableViewController: UITableViewController {

    func closeExpandableTableViewCells(excluding indexPath: IndexPath? = nil) {
        for case let cell as ExpandableTableViewCell in tableView.visibleCells where tableView.indexPath(for: cell) != indexPath && cell.isExpanded {
            cell.isExpanded = false
        }
    }

    var visibleBottomMargin: CGFloat {
        let superviewHeight = tableView.superview!.frame.height
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            return superviewHeight - tabBarHeight
        } else {
            return superviewHeight
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.beginUpdates()

        guard let expandableCell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell else {
            return indexPath
        }
        let cellRectInTableView = tableView.rectForRow(at: indexPath)
        if !expandableCell.isExpanded {
            // Ensure fully expanded cell is made visible when tapped near the bottom of the screen
            closeExpandableTableViewCells(excluding: indexPath)
            let cellRectInScreen = tableView.convert(cellRectInTableView, to: tableView.superview)
            if (cellRectInScreen.maxY * 1.5) > visibleBottomMargin {
                // Give contentSize enough space to ensure scrollRectToVisible works smoothly
                tableView.contentSize.height += 10 * cellRectInTableView.height
                let rectAtBottomOfCell = CGRect(x: 0, y: cellRectInTableView.maxY, width: 1, height: 1)
                tableView.scrollRectToVisible(rectAtBottomOfCell, animated: true)
            }
        }

        // An attempt at fixing jerky scrolling behavior at the bottom of the table view
//        else {
//            let lastSection = tableView.numberOfSections - 1
//            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
//            let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
//            if tableView.indexPathsForVisibleRows!.contains(lastIndexPath) {
//                let adjustedInsets = UIEdgeInsets(top: originalContentInset.top, left: originalContentInset.left, bottom: expandableCell.expandedViewHeight, right: originalContentInset.right)
//                tableView.contentInset = adjustedInsets
//            }
//        }

        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)

        guard let expandableCell = tableView.cellForRow(at: indexPath) as? ExpandableTableViewCell else { return }
        let cellRectInTableView = tableView.rectForRow(at: indexPath)
        if expandableCell.isExpanded {
            // Ensure fully expanded cell is made visible when tapped near the bottom of the screen
            let cellRectInScreen = tableView.convert(cellRectInTableView, to: tableView.superview)
            if cellRectInScreen.maxY > visibleBottomMargin {
                // Give contentSize enough space to ensure scrollRectToVisible works smoothly
                tableView.contentSize.height += 10 * cellRectInTableView.height
                let rectAtBottomOfCell = CGRect(x: 0, y: cellRectInTableView.maxY, width: 1, height: 1)
                tableView.scrollRectToVisible(rectAtBottomOfCell, animated: true)
            }
        }
    }
}
