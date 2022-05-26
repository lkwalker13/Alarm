//
//  View+EasyAnchor.swift
//  Alarm v.2
//
//  Created by Евгений Лянкэ on 24.05.2022.
//

import UIKit

struct AnchoredConstraints {
    var topAnchor, leadingAnchor, bottomAnchor, trailingAnchor :NSLayoutConstraint?
}



extension UIView {
    
    @discardableResult
    func         anchor(top:NSLayoutYAxisAnchor?,leading:NSLayoutXAxisAnchor?,bottom:NSLayoutYAxisAnchor?,trailing:NSLayoutXAxisAnchor?,padding:UIEdgeInsets = .zero,size:CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        if let  top = top {
            anchoredConstraints.topAnchor = topAnchor.constraint(equalTo: top,constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leadingAnchor = leadingAnchor.constraint(equalTo: leading,constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottomAnchor = bottomAnchor.constraint(equalTo: bottom,constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailingAnchor = trailingAnchor.constraint(equalTo: trailing,constant: -padding.right)
        }
        
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        [anchoredConstraints.topAnchor,anchoredConstraints.leadingAnchor,anchoredConstraints.bottomAnchor,anchoredConstraints.trailingAnchor].forEach { anchor in
            anchor?.isActive = true
        }
        return anchoredConstraints
    }
    
    func centerAnchor(size:CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = superview{
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
        if let superview = superview{
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillSuperView(){
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    
}
