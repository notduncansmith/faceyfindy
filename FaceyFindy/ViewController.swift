//
//  ViewController.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/20/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import UIKit 
import SwiftyCam
import Interstellar

class ViewController : SwiftyCamViewController {
  @IBOutlet weak var trainingModeSwitch: UISwitch!
  @IBOutlet weak var faceWindow: UIImageView!
  
  let indicatorView = UIView()
  let rawIncomingImages = Observable<UIImage>()
  let incomingFaceImages = Observable<UIImage>()
  let predictions = Observable<(String, Int)>()
  
  let currentModelName = "default"
  let faceModel = FaceModel()
  let minTrainingImages = 5
  let photoInterval: TimeInterval = 0.1
  
  var trainingCount = 0
  var frameTimer = Timer()
  var stopTakingPhotos: Block?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewSize = view.bounds.size
    
    view.addSubview(indicatorView)
    view.bringSubview(toFront: indicatorView)
    indicatorView.layer.borderColor = UIColor.cyan.cgColor
    indicatorView.layer.borderWidth = 2
    
    view.bringSubview(toFront: faceWindow)
    view.bringSubview(toFront: trainingModeSwitch)
    
    cameraDelegate = self
    
    rawIncomingImages.subscribe { image in
      let faceRects = FaceModel.faceRects(from: image)
      let ci = CIImage(cgImage: image.cgImage!)
      let ciImageSize = ci.extent.size
      let isMirrored = (self.currentCamera == .front)
      let indicatorScaleHeight = viewSize.height / ciImageSize.width
      var indicatorScaleWidth = viewSize.width / ciImageSize.height
      
      if (isMirrored) {
        indicatorScaleWidth *= -1
      }
      
      faceRects.forEach { faceRect in
        // This transform transposes the image from the coreimage
        // coordinates to uikit's coordinate system
        let indicatorTransform = CGAffineTransform(
          a: 0, b: indicatorScaleHeight, c: indicatorScaleWidth,
          d: 0, tx: 0, ty: 0
        )
        
        self.indicatorView.frame = faceRect.applying(indicatorTransform)
        self.indicatorView.alpha = 1.0
        
        let faceImage = image.crop(to: faceRect)

        self.incomingFaceImages.update(faceImage)
      }
      
      if faceRects.isEmpty {
        self.indicatorView.alpha = 0.0
      }
    }
    
    incomingFaceImages.subscribe { faceImage in
      self.displayInWindow(image: faceImage)
      
      if (self.trainingModeSwitch.isOn) {
        self.faceModel.addSample(
          image: faceImage,
          name: self.currentModelName
        )
        self.trainingCount += 1
        toast("Captured \(self.trainingCount) training images")
      }
      else if (self.trainingCount > self.minTrainingImages) {
        // We're emitting a confidence value no matter what we match
        // When supporting multiple labels, we'll need to discriminate here
        let distance = self.faceModel.distanceFromNearestMatch(image: faceImage)
        let confidence: Int = Int(floor(abs(distance - 100)))
        self.predictions.update((self.currentModelName, confidence))
      }
    }
    
    predictions.subscribe { (label: String, confidence: Int) in
      toast("Detected \(label) face with \(confidence)% confidence")
    }
    
    after(seconds: 0.5) {
      self.stopTakingPhotos = every(seconds: self.photoInterval) {
        self.takePhoto()
      }
    }
  }
  
  func displayInWindow(image: UIImage) {
    faceWindow.image = image
  }  
extension ViewController : SwiftyCamViewControllerDelegate {
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
    rawIncomingImages.update(photo)
  }
}
