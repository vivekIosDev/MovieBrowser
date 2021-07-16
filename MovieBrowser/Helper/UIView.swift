//
//  UIView.swift
//  MovieBrowser
//
//  Created by Mac-6 on 14/07/21.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func roundedCorner(height:CGFloat,color:UIColor)  {
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = height / 2
    }
    
    

    func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setBottomBorder(color: UIColor, height: CGFloat) {
        let border = CALayer()
        border.frame = CGRect(
            x: 0,
            y: self.bounds.height - height,
            width:  self.bounds.width,
            height: height
        )
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
        border.zPosition = 1
    }

    
    func setCornerRadius(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }

    func addShadowToViewFor(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }


    func addShadowToView(color: UIColor? = .darkGray) {
        let shadowPath = UIBezierPath(rect: self.bounds)
        layer.masksToBounds = false
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = CGSize(width: 0,height: 0)
        layer.shadowOpacity = 0.6
        //layer.shadowRadius = 8.0
        layer.cornerRadius = 5
        layer.shadowPath = shadowPath.cgPath

    }

    func addShadowToView(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }

    func addShadowToViewForChecklist(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 2
    }

    func addShadowToViewTemplate(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }

    func addShadowToView(color: UIColor = UIColor.gray, cornerRadius: CGFloat,backgroundColor: UIColor = .white) {
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = 5
    }

    func constraintsEqualToSuperView() {
        if let superview = self.superview {
            NSLayoutConstraint.activate(
                [
                    self.topAnchor.constraint(
                        equalTo: superview.topAnchor
                    ),
                    self.bottomAnchor.constraint(
                        equalTo: superview.bottomAnchor
                    ),
                    self.leadingAnchor.constraint(
                        equalTo: superview.leadingAnchor
                    ),
                    self.trailingAnchor.constraint(
                        equalTo: superview.trailingAnchor
                    )
                ]
            )
        }
    }

    func constraintsEqualToSuperViewWithMargins() {
        if let superview = self.superview {
            NSLayoutConstraint.activate(
                [
                    self.topAnchor.constraint(
                        equalTo: superview.layoutMarginsGuide.topAnchor
                    ),
                    self.bottomAnchor.constraint(
                        equalTo: superview.layoutMarginsGuide.bottomAnchor
                    ),
                    self.leadingAnchor.constraint(
                        equalTo: superview.leadingAnchor
                    ),
                    self.trailingAnchor.constraint(
                        equalTo: superview.trailingAnchor
                    )
                ]
            )
        }
    }
}


extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            //For Center Line
            border.frame = CGRect(x: self.frame.width/2 - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        }
        
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

extension UIView {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            /// we're using `first` here because compact map chokes compiler on
            /// optimized release, so you can't use two views in one nib if you wanted to
            /// and are now looking at this
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }
}
