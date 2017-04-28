//
//  ViewController+SwiftyCamViewControllerDelegate.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/27/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import Foundation
import SwiftyCam

extension ViewController : SwiftyCamViewControllerDelegate {
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
    rawIncomingImages.update(photo)
  }
}
