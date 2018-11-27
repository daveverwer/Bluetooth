//
//  GAPDataEncoder.swift
//  Bluetooth
//
//  Created by Alsey Coleman Miller on 8/25/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation

public extension GAP {
    
    public typealias DataEncoder = GAPDataEncoder
}

public struct GAPDataEncoder {
    
    public enum Error: Swift.Error {
        
        case invalidSize(Int)
    }
    
    public init() { }
    
    public func encode(_ encodables: GAPData...) -> Data {
        
        let dataLengths = encodables.map { $0.dataLength }
        let length = dataLengths.reduce(0, { $0 + $1 + 2 })
        var data = Data(capacity: length)
        
        for (index, encodable) in encodables.enumerated() {
            
             let dataLength = dataLengths[index]
            
            data += UInt8(dataLength + 1)
            data += type(of: encodable).dataType.rawValue
            encodable.append(to: &data)
        }
        
        return data
    }
    
    public func encodeAdvertisingData(_ encodables: GAPData...) throws -> LowEnergyAdvertisingData {
        
        let dataLengths = encodables.map { $0.dataLength }
        let length = dataLengths.reduce(0, { $0 + $1 + 2 })
        
        guard length <= LowEnergyAdvertisingData.capacity
            else { throw Error.invalidSize(length) }
        
        var data = LowEnergyAdvertisingData()
        
        for (index, encodable) in encodables.enumerated() {
            
            let dataLength = dataLengths[index]
            
            data += UInt8(dataLength + 1)
            data += type(of: encodable).dataType.rawValue
            encodable.append(to: &data)
        }
        
        return data
    }
}

public struct GAPDataDecoder {
    
    public enum Error: Swift.Error {
        
        case insufficientBytes(expected: Int, actual: Int)
        case cannotDecode(GAPDataType, index: Int)
        case unknownType(GAPDataType)
    }
    
    public init() { }
    
    public var ignoreUnknownType: Bool = false
    
    public var types: [GAPData.Type] = gapDataTypes
    
    public func decode(_ data: LowEnergyAdvertisingData) throws -> [GAPData] {
        
        
    }
    
    public func decode(_ data: Data) throws -> [GAPData] {
        
        guard data.isEmpty == false
            else { return [] }
        
        var elements = [GAPData]()
        elements.reserveCapacity(1)
        
        var index = 0
        
        while index < data.count {
            
            // get length
            let length = Int(data[index]) // 0
            index += 1
            guard index < data.count else {
                
                if length == 0 {
                    
                    break // EOF
                    
                } else {
                    
                    throw Error.insufficientBytes(expected: index + 1, actual: data.count)
                }
            }
            
            // get type
            let type = GAPDataType(rawValue: data[index]) // 1
            
            // ignore zeroed bytes
            guard (type.rawValue == 0 && length == 0) == false
                else { break }
            
            // get value
            let value: Data
            
            if length > 0 {
                
                let dataRange = index + 1 ..< index + length // 2 ..< 2 + length
                index = dataRange.upperBound
                guard index <= data.count
                    else { throw Error.insufficientBytes(expected: index + 1, actual: data.count) }
                
                value = data.subdataNoCopy(in: dataRange)
                
            } else {
                
                value = Data()
            }
            
            if let gapType = types.first(where: { $0.dataType == type }) {
                
                guard let decodable = gapType.init(data: value)
                    else { throw Error.cannotDecode(type, index: index) }
                
                elements.append(decodable)
                
            } else if ignoreUnknownType {
                
                continue
                
            } else {
                
                throw Error.unknownType(type)
            }
        }
        
        return elements
    }
}

internal let gapDataTypes: [GAPData.Type] = [
    GAPFlags.self,
    GAPIncompleteListOf16BitServiceClassUUIDs.self,
    GAPCompleteListOf16BitServiceClassUUIDs.self,
    GAPIncompleteListOf32BitServiceClassUUIDs.self,
    GAPCompleteListOf32BitServiceClassUUIDs.self,
    GAPIncompleteListOf128BitServiceClassUUIDs.self,
    GAPCompleteListOf128BitServiceClassUUIDs.self,
    GAPShortLocalName.self,
    GAPCompleteLocalName.self,
    GAPTxPowerLevel.self,
    GAPClassOfDevice.self,
    GAPSimplePairingHashC.self,
    // TODO
]
