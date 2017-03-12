//
//  UIButton+ BackgroundColor.swift
//  Sift
//
//  Created by Kyle Chronis on 3/8/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, state: UIControlState) {
        self.setBackgroundImage(self.image(color: color), for: state)
    }
    
    private func image(color: UIColor) -> (UIImage) {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 1.0, height: 1.0))
        
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()!;
        
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        return image;
    }
}
