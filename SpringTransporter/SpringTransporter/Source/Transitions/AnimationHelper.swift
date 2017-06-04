//
//  AnimationHelper.swift
//  SpringTransporter
//
//  Created by 史翔新 on 2017/06/04.
//  Copyright © 2017年 kirinsan.org. All rights reserved.
//

import UIKit

struct AnimationHelper {
	static func yRotation(_ angle: Double) -> CATransform3D {
		return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
	}
	
	static func perspectiveTransformForContainerView(_ containerView: UIView) {
		var transform = CATransform3DIdentity
		transform.m34 = -0.002
		containerView.layer.sublayerTransform = transform
	}
}
