//
//  CircleProgressBarItem.swift
//  CircleProgressBar
//
//  Created by YANG XU on 2018/07/21.
//  Copyright © 2018年 YANG XU. All rights reserved.
//

import Foundation

public struct CircleProgressBarItem: Comparable {
    
    var value: CGFloat
    var strokeWidth: CGFloat
    var strokeColor: UIColor
    
    public init(_ value: CGFloat, strokeWidth: CGFloat, strokeColor: UIColor) {
        self.value = value
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }
    
    public static func < (lhs: CircleProgressBarItem, rhs: CircleProgressBarItem) -> Bool {
        return lhs.strokeWidth < rhs.strokeWidth
    }
}
