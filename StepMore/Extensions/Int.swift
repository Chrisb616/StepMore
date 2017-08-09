//
//  Int.swift
//  StepMore
//
//  Created by Christopher Boynton on 8/4/17.
//  Copyright © 2017 Self. All rights reserved.
//

import Foundation

extension Int {
    
    var asString: String {
        
        var string = String(describing: self)
        var characters = Array(string.characters)
        
        for i in 1...string.count {
            
            if (i) % 3 == 0 {
                characters.insert(",", at: string.count - i)
            }
            
        }
        
        var result = ""
        result.append(contentsOf: characters)
        
        return result
        
    }
    
}
