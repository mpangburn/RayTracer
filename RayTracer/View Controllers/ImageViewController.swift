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
    var spheresImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Image", comment: "The title text for the ray-traced image screen")
        setupImageView()
        setupScrollView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if RayTracer.shared.sceneNeedsRendering {
            presentLoadingView(message: "Rendering image...")

            // Move to a background thread to render the image
            DispatchQueue.global(qos: .userInteractive).async {
                let image = self.renderImage()

                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.spheresImageView.frame.size.width = image.size.width
                    self.spheresImageView.frame.size.height = image.size.height
                    self.spheresImageView.image = image
                    self.scrollView.zoomScale = 1.0
                    self.updateScrollView()
                    self.dismissLoadingView()
                }
            }
        }
    }

    private func setupImageView() {
        let image = UIImage(Image(pixelData: Array<Color.PixelData>(repeating: Color.white.pixelData, count: 1), width: 1, height: 1))
        spheresImageView = UIImageView(image: image)
        scrollView.addSubview(spheresImageView)
    }

    private func renderImage() -> UIImage {
        let image = RayTracer.shared.castAllRays()
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

        let minScale = min(widthScale, heightScale)
        let baseScale: CGFloat = 1.0
        if minScale < baseScale {
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = baseScale
        } else {
            scrollView.minimumZoomScale = baseScale
            scrollView.maximumZoomScale = minScale
        }

        scrollView.zoomScale = baseScale
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
        activityViewController.excludedActivityTypes = [.assignToContact]
        self.present(activityViewController, animated: true)
    }

    // MARK: - Debugging
    private func printFramesInfo() {
        print("Settings Frame: \(RayTracer.shared.settings.sceneFrame)")
        print("ImageView Frame: \(spheresImageView.frame)")
        print("ImageView Bounds: \(spheresImageView.bounds)")
        print("Image Size: \(spheresImageView.image!.size)")
    }

    private func printScrollViewInfo() {
        print("=====SCROLL VIEW =====")
        print("Frame: \(scrollView.frame)")
        print("Bounds: \(scrollView.bounds)")
        print("Content Inset: \(scrollView.contentInset)")
        print("Min Zoom Scale: \(scrollView.minimumZoomScale)")
        print("Max Zoom Scale: \(scrollView.maximumZoomScale)")
        print("Zoom Scale: \(scrollView.zoomScale)")
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

