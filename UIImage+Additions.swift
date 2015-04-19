//
//  UIImage+Additions.swift
//  Modularm
//
//  Created by Gregory Klein on 4/19/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

import UIKit

extension UIImage
{
   var templateImage: UIImage {
      get {
         return self.imageWithRenderingMode(.AlwaysTemplate)
      }
   }
}