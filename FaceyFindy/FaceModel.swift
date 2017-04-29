//
//  FaceModel.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/21/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import Foundation

let sharedFaceDetector = CIDetector(
  ofType: CIDetectorTypeFace,
  context: nil,
  options: [
    CIDetectorAccuracy: CIDetectorAccuracyHigh,
    CIDetectorNumberOfAngles: 9
  ])!

class FaceModel {
  static let defaultRecognizer = FFFaceRecognizer.lbph()!
  var fr: FFFaceRecognizer
  
  init(recognizer: FFFaceRecognizer = FaceModel.defaultRecognizer) {
    fr = recognizer
  }
  
  func addSample(image: UIImage, name: String) {
    fr.update(withFace: image, name: name)
  }
  
  func distanceFromNearestMatch(image: UIImage) -> Double {
    var confidence = Double()
    let _: String? = fr.predict(image, confidence: &confidence)
    
    return confidence
  }
  
  static func faceRects(from image: UIImage) -> [CGRect] {
    if let cg = image.cgImage {
      let ci = CIImage(cgImage: cg)
      let features = sharedFaceDetector.features(in: ci)
      
      return features
      .filter { $0.type == CIFeatureTypeFace }
      .map { $0.bounds }
    }
    else {
      print("Failed to read features from detector.")
      return []
    }
  }
}
