//
//  UIImage+crop.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/27/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import Foundation

extension UIImage {
  func crop(to rect: CGRect) -> UIImage {
    if let cg = self.cgImage {
      let offset = CGRect(
        origin: CGPoint(
          x: rect.origin.x,
          y: self.size.width - rect.origin.y - rect.height
        ),
        size: rect.size
      )
      
      print("\(rect.origin.x) , \(rect.origin.y)")
      
      if let cropped = cg.cropping(to: offset) {
        return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation)
      }
      else {
        print("Unable to crop image \(self.size) to \(offset) (computed from \(rect))")
      }
    }
    else {
      print("Unable to crop non-CGImage-based images for now")
    }
    
    return self
  }
}
