//
//  FinishTableViewCell.swift
//  RayTracer
//
//  Created by Michael Pangburn on 7/9/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit


protocol FinishTableViewCellDelegate: class {
    func finishTableViewCellFinishDidChange(_ cell: FinishTableViewCell)
}


final class FinishTableViewCell: ExpandableTableViewCell {

    weak var delegate: FinishTableViewCellDelegate?

    var finish: Finish {
        get {
            return Finish(ambient: Double(ambientSlider.value),
                          diffuse: Double(diffuseSlider.value),
                          specular: Double(specularSlider.value),
                          roughness: Double(roughnessSlider.value))
        }
        set {
            ambientSlider.value = Float(newValue.ambient)
            diffuseSlider.value = Float(newValue.diffuse)
            specularSlider.value = Float(newValue.specular)
            roughnessSlider.value = Float(newValue.roughness)
            updateComponentsLabel()
        }
    }

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = NSLocalizedString("Finish", comment: "The title text for the finish editing cell")
        }
    }

    @IBOutlet weak var componentsLabel: UILabel!

    @IBOutlet weak var ambientLabel: UILabel! {
        didSet {
            ambientLabel.text = NSLocalizedString("ambient", comment: "The text for the ambient finish component slider label")
        }
    }

    @IBOutlet weak var diffuseLabel: UILabel! {
        didSet {
            diffuseLabel.text = NSLocalizedString("diffuse", comment: "The text for the diffuse finish component slider label")
        }
    }

    @IBOutlet weak var specularLabel: UILabel! {
        didSet {
            specularLabel.text = NSLocalizedString("specular", comment: "The text for the specular finish component slider label")
        }
    }

    @IBOutlet weak var roughnessLabel: UILabel! {
        didSet {
            roughnessLabel.text = NSLocalizedString("roughness", comment: "The text for the roughness finish component slider label")
        }
    }

    @IBOutlet weak var ambientSlider: UISlider!
    @IBOutlet weak var diffuseSlider: UISlider!
    @IBOutlet weak var specularSlider: UISlider!
    @IBOutlet weak var roughnessSlider: UISlider!

    @IBOutlet weak var slidersWrapperView: UIView! {
        didSet {
            expandableView = slidersWrapperView
        }
    }

    @IBOutlet weak var slidersWrapperViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            expandableViewHeightConstraint = slidersWrapperViewHeightConstraint
        }
    }

    private func updateComponentsLabel() {
        let finish = self.finish
        componentsLabel.text = "\(finish.ambient.integerPercentage) | \(finish.diffuse.integerPercentage) | \(finish.specular.integerPercentage) | \(finish.roughness.twoDigitDecimalString)"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateComponentsLabel()
        delegate?.finishTableViewCellFinishDidChange(self)
    }
}
