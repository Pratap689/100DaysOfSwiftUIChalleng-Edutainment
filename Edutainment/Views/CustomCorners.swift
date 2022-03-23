//
//  CustomCorners.swift
//  Edutainment
//
//  Created by netset on 08/03/22.
//

import Foundation
import SwiftUI

struct CustomCoreners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
