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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Image", comment: "The title text for the ray-traced image screen")
        setupScrollView()
    }

    override func viewDidAppear(_ animated: Bool) {
        if RayTracer.shared.sceneNeedsRendering {
            presentLoadingView(message: "Rendering image...")

            // Move to a background thread to render the image
            DispatchQueue.global(qos: .userInitiated).async {
                let image = self.renderImage()

                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.spheresImageView.image = image
                    self.spheresImageViewHeightConstraint.constant = image.size.height
                    self.spheresImageViewWidthConstraint.constant = image.size.width
                    self.updateScrollView()
                    self.dismissLoadingView()
                }
            }
        }
    }

    private func renderImage() -> UIImage {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Failed to access AppDelegate")
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Sphere> = Sphere.fetchRequest()
        let tracer = RayTracer.shared

        do {
            tracer.spheres = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching sphere data")
        }

        let image = tracer.castAllRays()
        guard let renderedImage = UIImage(image) else {
            fatalError("Failed to render image into UIImage")
        }

        return renderedImage
    }

    private func setupScrollView() {
        scrollView.delegate = self
        setupTapToZoomGestureRecognizer()
    }

    private func updateScrollView() {
        setZoomScale()
        centerScrollViewContents()
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
        updateScrollView()
    }

    private func setZoomScale() {
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

