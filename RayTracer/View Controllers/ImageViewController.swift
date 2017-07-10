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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Image", comment: "The title text for the ray-traced image screen")
//        activityIndicatorView.startAnimating()
//        processImage()
//        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        setupScrollView()
//        setZoomScale()
//        centerScrollViewContents()
    }

    override func viewWillAppear(_ animated: Bool) {
        processImage()
//        setupScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
//        processImage()
//        setupScrollView()
        setZoomScale()
        centerScrollViewContents()
    }

    private func processImage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        var spheres: [Sphere] = []
        do {
            spheres = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sphere data")
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
        centerScrollViewContents()
    }

    fileprivate func setZoomScale() {
        let imageViewSize = spheresImageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }

    fileprivate func centerScrollViewContents() {
        let imageViewSize = spheresImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        let horizontalPadding = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
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
        centerScrollViewContents()
    }
}

