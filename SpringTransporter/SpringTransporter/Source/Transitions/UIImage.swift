//
//  UIImage.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

extension UIImage {
	
	class func renderImage(from view: UIView) -> UIImage? {
		
		UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
		let context = UIGraphicsGetCurrentContext()
		view.layer.render(in: context!)
		let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return renderedImage
		
	}
	
}
