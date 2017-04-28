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
      return UIImage(cgImage: cg.cropping(to: rect)!, scale: self.scale, orientation: self.imageOrientation)
    } else {
      print("Unable to crop non-CGImage-based images for now")
      return self
    }
  }
}
