//
//  C7FilterTexture.swift
//  Harbeth
//
//  Created by Condy on 2022/2/21.
//

import Foundation
import MetalKit

public struct C7FilterTexture {
    
    public let inputTexture: MTLTexture
    public lazy var destTexture: MTLTexture = { inputTexture }()
    
    public init(texture: MTLTexture) {
        inputTexture = texture
    }
}

extension C7FilterTexture: C7FilterSerializer {
    
    public mutating func make<T>(filter: C7FilterProtocol) throws -> T where T : C7FilterSerializer {
        do {
            let otherTextures = filter.otherInputTextures
            let outTexture = try newTexture(inTexture: inputTexture, otherTextures: otherTextures, filter: filter)
            self.destTexture = outTexture
            return self as! T
        } catch {
            throw error
        }
    }
    
    public mutating func makeGroup<T>(filters: [C7FilterProtocol]) throws -> T where T : C7FilterSerializer {
        var outTexture: MTLTexture = self.inputTexture
        for filter in filters {
            let otherTextures = filter.otherInputTextures
            if let texture = try? newTexture(inTexture: outTexture, otherTextures: otherTextures, filter: filter) {
                outTexture = texture
            }
        }
        self.destTexture = outTexture
        return self as! T
    }
}
