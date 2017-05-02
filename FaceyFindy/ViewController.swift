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
  let incomingFaces = Observable<Face>()
  let trainingFaces = Observable<Face>()
  let testingFaces = Observable<Face>()
  let predictions = Observable<(String, Int)>()
  
  let currentModelName = "default"
  let minTrainingImages = 5
  let photoInterval: TimeInterval = 0.1
  
  var trainingCount = 0
  var frameTimer = Timer()
  var stopTakingPhotos: Block?
  var isTrainingMode: Bool {
    get {
      return self.trainingModeSwitch.isOn
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(indicatorView)
    
    view.bringSubview(toFront: indicatorView)
    view.bringSubview(toFront: faceWindow)
    view.bringSubview(toFront: trainingModeSwitch)
    
    indicatorView.layer.borderColor = UIColor.cyan.cgColor
    indicatorView.layer.borderWidth = 2
    
    cameraDelegate = self
    
    previewDetectedFaces()
    predictLabelsForTestFaces()
    rememberTrainingFaces()
    
    rawIncomingImages.subscribe { image in
      let faces = Face.findAll(in: image)
      
      if faces.isEmpty {
        self.hideIndicator()
      }
      
      faces.forEach { face in
        let overlayRect = self.overlay(forFace: face)
        self.showIndicator(at: overlayRect)
        
        if let faceImage = face.image {
          self.displayInWindow(image: faceImage)
        }
        
        if (self.isTrainingMode) {
          self.trainingFaces.update(face)
        }
        else {
          self.testingFaces.update(face)
        }
      }
    }
    
    after(seconds: 0.5) {
      self.stopTakingPhotos = every(seconds: self.photoInterval) {
        self.takePhoto()
      }
    }
  }
  
  func rememberTrainingFaces() {
    trainingFaces.subscribe { face in
      face.attachLabel(self.currentModelName)
      
      self.trainingCount += 1
      toast("Captured \(self.trainingCount) training images")
    }
  }
  
  func predictLabelsForTestFaces() {
    testingFaces.subscribe { face in
      if (self.trainingCount > self.minTrainingImages) {
        let distance = Int(floor(face.distanceFromNearestMatch()))
        toast("Distance to closest match (\"\(self.currentModelName)\"): \(distance)")
      }
    }
  }
  
  func previewDetectedFaces() {
    incomingFaces.subscribe { face in
      if let faceImage = face.image {
        self.displayInWindow(image: faceImage)
      }
    }
  }
  
  func displayInWindow(image: UIImage) {
    faceWindow.image = image
  }
  
  // Overlay the indicator onto a particular face
  func overlay(forFace face: Face) -> CGRect {
    let ci = CIImage(cgImage: face.originalImage.cgImage!)
    let ciSize = ci.extent.size
    let viewSize = view.bounds.size
    let isMirrored = (self.currentCamera == .front) // images from selfie cam are flipped horizontally
    
    // Don't be fooled!
    // Because of the multiple iOS coordinate systems, viewSize.height
    // and ciSize.width refer to the same measure despite their names.
    let scaleHeight = viewSize.height / ciSize.width
    var scaleWidth = viewSize.width / ciSize.height
    
    // This transform transposes the image from CoreImage's to UIKit's coordinate system
    let transform = CGAffineTransform(
      a: 0, b: scaleHeight, c: scaleWidth,
      d: 0, tx: 0, ty: 0
    )
    
    // Flip the image horizontally to compensate for
    // any mirroring due to e.g. selfie mode.
    if isMirrored {
      scaleWidth *= -1
    }
    
    return face.bounds.applying(transform)
  }
  
  func showIndicator(at rect: CGRect) {
    UIView.animate(withDuration: 0.05, animations: {
      // Expand and fade out
      self.indicatorView.alpha = 1.0
      self.indicatorView.frame = rect
    })
  }
  
  func hideIndicator() {
    UIView.animate(withDuration: 0.05, animations: {
      // Expand and fade out
      self.indicatorView.alpha = 0.0
      self.indicatorView.frame.size.height += 200
      self.indicatorView.frame.size.width += 200
      self.indicatorView.frame.origin.x -= 100
      self.indicatorView.frame.origin.y -= 100
    })
  }
}

extension ViewController : SwiftyCamViewControllerDelegate {
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
    rawIncomingImages.update(photo)
  }
}
