//
//  ImageViewController.swift
//  RayTracer-iOS
//
//  Created by Michael Pangburn on 7/6/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import UIKit
import CoreData


class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var spheresImageView: UIImageView!
    @IBOutlet weak var spheresImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spheresImageViewWidthConstraint: NSLayoutConstraint!

    var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    override func viewDidLoad() {
        super.viewDidLoad()

        let managedObjectContext = container.viewContext
        let sphereDataString = "1.0 1.0 0.0 2.0 1.0 0.0 1.0 0.2 0.4 0.5 0.05\n8.0 -10.0 110.0 100.0 0.2 0.2 0.6 0.4 0.8 0.0 0.05"
        var spheres: [Sphere] = []
        for sphereString in sphereDataString.components(separatedBy: "\n") {
            if let sphere = Sphere(string: sphereString, context: managedObjectContext) {
                spheres.append(sphere)
            }
        }

        let frame = RayTracer.Defaults.frame
        let image = RayTracer.castAllRays(on: spheres,
                                          in: frame,
                                          with: RayTracer.Defaults.ambient,
                                          under: RayTracer.Defaults.light,
                                          viewedFrom: RayTracer.Defaults.eye)
        spheresImageViewHeightConstraint.constant = CGFloat(frame.height)
        spheresImageViewWidthConstraint.constant = CGFloat(frame.width)
        spheresImageView.image = UIImage(image)

        setupScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
        setZoomScale()
    }

    private func setupScrollView() {
        scrollView.delegate = self
        setupTapToZoomGestureRecognizer()
    }

    private func setupTapToZoomGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }

    @objc private func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        let zoomScale = scrollView.zoomScale > scrollView.minimumZoomScale ? scrollView.minimumZoomScale : scrollView.maximumZoomScale
        scrollView.setZoomScale(zoomScale, animated: true)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setZoomScale()
    }

    fileprivate func setZoomScale() {
        let imageViewSize = spheresImageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }

    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [spheresImageView.image as Any], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return spheresImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = spheresImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        let horizontalPadding = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

