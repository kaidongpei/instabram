//
//  CornerRadius.swift
//  xmlDemo
//
//  Created by kaidong pei on 11/3/17.
//  Copyright © 2017 kaidong pei. All rights reserved.
//

import UIKit

extension UIView{
    @IBInspectable var ViewCorner: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

//extension UIImage{
//    @IBInspectable var ViewCorner: CGFloat{
//        get{
//            return layer.cornerRadius
//        }
//        set{
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//}

extension UIButton{
    @IBInspectable var btnCorner: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UILabel{
    @IBInspectable var labelCorner: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

