//
//  UIColorExtension.swift
//  tkyield
//
//  Created by Kevin on 9/1/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit
extension UIImage {
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext();
        print(color)
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.redColor().setFill()
        }
        
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
}
