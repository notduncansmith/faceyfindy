//
//  Face.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/28/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import Foundation

struct Face {
  private static let sharedRecognizer = FFFaceRecognizer.lbph()!
  private static let sharedDetector = CIDetector(
    ofType: CIDetectorTypeFace,
    context: nil,
    options: [
      CIDetectorAccuracy: CIDetectorAccuracyHigh,
      CIDetectorNumberOfAngles: 9
    ]
  )!
  private static var sharedStringLabels = [String:Int32]()
  private static var sharedIntLabels = [Int32:String]()
  
  var originalImage: UIImage!
  var bounds: CGRect!
  var image: UIImage?
  
  init(in image: UIImage!, at rect: CGRect!, forgettable: Bool = false) {
    self.originalImage = image
    self.bounds = rect
    self.image = self.cropped()
  }
  
  static func findAll(in image: UIImage) -> [Face] {
    if let cg = image.cgImage {
      let ci = CIImage(cgImage: cg)
      let features = Face.sharedDetector.features(in: ci)
      
      return features
        .filter { $0.type == CIFeatureTypeFace }
        .map { Face(in: image, at: $0.bounds) }
    }
    else {
      print("Failed to read features from detector.")
      return []
    }
  }
  
  func nearestMatch() -> (label: String?, distance: Int) {
    var distance = Double()
    let intLabel = Face.sharedRecognizer.predict(image, distance: &distance)
    
    return (label: Face.sharedIntLabels[intLabel], distance: Int(floor(distance)))
  }
  
  func attachLabel(_ stringLabel: String) {
    if let img = image {
      if let intLabel = Face.sharedStringLabels[stringLabel] {
        Face.sharedRecognizer.update(withFace: img, label: intLabel)
      }
      else {
        // Not thread-safe
        let intLabel = Int32(Face.sharedStringLabels.count)
        Face.sharedIntLabels[intLabel] = stringLabel
        Face.sharedStringLabels[stringLabel] = intLabel
        Face.sharedRecognizer.update(withFace: img, label: intLabel)
      }
    }
    else {
      // There's no image, so nothing to do here
    }
  }
  
  // Return the original UIImage cropped to just the face
  func cropped() -> UIImage? {
    var adjusted = bounds! // We call this in the initializer, thus bounds is Optional-wrapped
    
    // Images from SwiftyCam (and JPEGs without EXIF metadata specifying otherwise) are
    // rotated 90 degrees counterclockwise from their intuitive orientation. This means
    // that origin.y value actually determines the x-alignment of the crop rect with the face
    
    adjusted.origin.y = originalImage.size.width - bounds.origin.y - bounds.height
    
    return originalImage.crop(to: adjusted)
  }
  
  func distanceFromNearestMatch() -> Double {
    var distance = Double()
    
    // Because we're only using one face, ignore the label returned
    let _ = Face.sharedRecognizer.predict(image, distance: &distance)
    
    return distance
  }
}
