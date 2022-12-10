//
//  SKNode+Extensions.swift
//  A Birds
//
//  Created by Jorge Giannotta on 15/05/2019.
//  Copyright © 2019 Westcostyle. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    func aspectScaleTo(to size: CGSize, width: Bool, multiplier: CGFloat) {
        
        let scale = width ? (size.width * multiplier) / self.frame.size.width : (size.height * multiplier) / self.frame.size.height
        
        self.setScale(scale)
    }
}
