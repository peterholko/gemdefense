//
//  Armor.swift
//  GemDefense
//
//  Created by Peter Holko on 2018-01-10.
//  Copyright © 2018 Peter Holko. All rights reserved.
//

import UIKit

class Armor {
    
    var armortablepos : [CGFloat] = Array(repeating: 0.0, count: 36)
    var armortableneg : [CGFloat] = Array(repeating: 0.0, count: 11)
    
    init() {
        armortablepos[0] = 1
        armortablepos[1] = 0.943
        armortablepos[2] = 0.893
        armortablepos[3] = 0.847
        armortablepos[4] = 0.806
        armortablepos[5] = 0.769
        armortablepos[6] = 0.735
        armortablepos[7] = 0.704
        armortablepos[8] = 0.676
        armortablepos[9] = 0.649
        armortablepos[10] = 0.625
        armortablepos[11] = 0.602
        armortablepos[12] = 0.581
        armortablepos[13] = 0.562
        armortablepos[14] = 0.543
        armortablepos[15] = 0.526
        armortablepos[16] = 0.510
        armortablepos[17] = 0.495
        armortablepos[18] = 0.481
        armortablepos[19] = 0.467
        armortablepos[20] = 0.455
        armortablepos[21] = 0.442
        armortablepos[22] = 0.431
        armortablepos[23] = 0.420
        armortablepos[24] = 0.410
        armortablepos[25] = 0.400
        armortablepos[26] = 0.391
        armortablepos[27] = 0.382
        armortablepos[28] = 0.373
        armortablepos[29] = 0.365
        armortablepos[30] = 0.357
        armortablepos[31] = 0.350
        armortablepos[32] = 0.342
        armortablepos[33] = 0.336
        armortablepos[34] = 0.329
        armortablepos[35] = 0.323
        
        armortableneg[1] = 1.060
        armortableneg[2] = 1.116
        armortableneg[3] = 1.169
        armortableneg[4] = 1.219
        armortableneg[5] = 1.266
        armortableneg[6] = 1.310
        armortableneg[7] = 1.352
        armortableneg[8] = 1.390
        armortableneg[9] = 1.427
        armortableneg[10] = 1.461
    }
    
    func getArmorModifier(armorValue: Int) -> CGFloat {
        if armorValue >= 0 {
            return armortablepos[armorValue]
        } else {
            let armorValueNeg = armorValue * -1
            
            if armorValueNeg > 10 {
                return armortableneg[10]
            } else {
                return armortableneg[armorValueNeg]
            }
        }
    }
}
