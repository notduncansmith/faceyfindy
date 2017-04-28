//
//  Util.swift
//  FaceyFindy
//
//  Created by Duncan Smith on 4/27/17.
//  Copyright © 2017 Duncan Smith. All rights reserved.
//

import Foundation
import RKDropdownAlert

typealias Block = ()->()

func every(seconds: TimeInterval, block: @escaping Block) -> Block {
  let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
    block()
  }
  
  return {
    timer.invalidate()
  }
}

func after(seconds: TimeInterval, block: @escaping Block) {
  Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { timer in
    block()
  }
}

func toast(_ message: String) {
  RKDropdownAlert.title(
    message,
    backgroundColor: UIColor.darkGray,
    textColor: UIColor.lightText,
    time: 1)
}
