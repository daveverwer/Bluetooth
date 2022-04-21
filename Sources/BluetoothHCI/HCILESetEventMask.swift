//
//  HCILESetEventMask.swift
//  Bluetooth
//
//  Created by Alsey Coleman Miller on 6/13/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation

// MARK: - BluetoothHostControllerInterface

public extension BluetoothHostControllerInterface {
    
    /// LE Set Event Mask Command
    ///
    /// The command is used to control which LE events are generated by the HCI for the Host.
    func setLowEnergyEventMask(_ eventMask: HCILESetEventMask.EventMask,
                               timeout: HCICommandTimeout = .default) async throws {
        
        let parameter = HCILESetEventMask(eventMask: eventMask)
        
        try await deviceRequest(parameter, timeout: timeout)
    }
}

// MARK: - HCI Command

/// LE Set Event Mask Command
///
/// The command is used to control which LE events are generated by the HCI for the Host.
///
/// If the bit in the LE Event Mask is set to a one, then the event associated with that bit will be enabled.
/// The Host has to deal with each event that is generated by an LE Controller.
/// The event mask allows the Host to control which events will interrupt it.
///
/// For LE events to be generated, the LE Meta Event bit in the Event Mask shall also be set.
/// If that bit is not set, then LE events shall not be generated, regardless of how the LE Event Mask is set.
@frozen
public struct HCILESetEventMask: HCICommandParameter {
    
    public typealias EventMask = BitMaskOptionSet<Event>
    
    public static let command = HCILowEnergyCommand.setEventMask // 0x0001
    
    /// The mask of LE events allowed to be generated by the HCI.
    public var eventMask: EventMask
    
    /// The value with all bits set to 0 indicates that no events are specified.
    /// The default is for bits 0 to 4 inclusive (the value 0x0000 0000 0000 001F) to be set.
    public init(eventMask: EventMask = 0x0000_0000_0000_001F) {
        
        self.eventMask = eventMask
    }
    
    public var data: Data {
        
        let eventMaskBytes = eventMask.rawValue.littleEndian.bytes
        
        return Data([
            eventMaskBytes.0,
            eventMaskBytes.1,
            eventMaskBytes.2,
            eventMaskBytes.3,
            eventMaskBytes.4,
            eventMaskBytes.5,
            eventMaskBytes.6,
            eventMaskBytes.7
        ])
    }
}

// MARK: - Supporting Types

public extension HCILESetEventMask {

    /// The value with all bits set to 0 indicates that no events are specified.
    /// The default is for bits 0 to 4 inclusive (the value `0x0000 0000 0000 001F`) to be set.
    ///
    /// All bits not listed in this table are reserved for future use.
    enum Event: UInt64, BitMaskOption, CustomStringConvertible {
        
        /// LE Connection Complete Event
        case connectionComplete                         = 0b00
        
        /// LE Advertising Report Event
        case advertisingReport                          = 0b01
        
        /// LE Connection Update Complete Event
        case connectionUpdateComplete                   = 0b10
        
        /// LE Read Remote Features Complete Event
        case readRemoteFeaturesComplete                 = 0b100
        
        /// LE Long Term Key Request Event
        case longTermKeyRequest                         = 0b1000
        
        /// LE Remote Connection Parameter Request Event
        case remoteConnectionParameterRequest           = 0b10000
        
        /// LE Data Length Change Event
        case dataLengthChange                           = 0b100000
        
        /// LE Read Local P-256 Public Key Complete Event
        case readLocalP256PublicKeyComplete             = 0b1000000
        
        /// LE Generate DHKey Complete Event
        case generateDHKeyComplete                      = 0b10000000
        
        /// LE Enhanced Connection Complete Event
        case enhancedConnectionComplete                 = 0b100000000
        
        /// LE Directed Advertising Report Event
        case directedAdvertisingReport                  = 0b1000000000
        
        /// LE PHY Update Complete Event
        case phyUpdateComplete                          = 0b10000000000
        
        /// LE Extended Advertising Report Event
        case extendedAdvertisingReport                  = 0b100000000000
        
        /// LE Periodic Advertising Sync Established Event
        case periodicAdvertisingSyncEstablished         = 0b1000000000000
        
        /// LE Periodic Advertising Report Event
        case periodicAdvertisingReport                  = 0b10000000000000
        
        /// LE Periodic Advertising Sync Lost Event
        case periodicAdvertisingSyncLost                = 0b100000000000000
        
        /// LE Extended Scan Timeout Event
        case extendedScanTimeout                        = 0b1000000000000000
        
        /// LE Extended Advertising Set Terminated Event
        case extendedAdvertisingSetTerminated           = 0b10000000000000000
        
        /// LE Scan Request Received Event
        case scanRequestReceived                        = 0b100000000000000000
        
        /// LE Channel Selection Algorithm Event
        case channelSelectionAlgorithm                  = 0b1000000000000000000
        
        public static let allCases: [Event] = [
            .connectionComplete,
            .advertisingReport,
            .connectionUpdateComplete,
            .readRemoteFeaturesComplete,
            .longTermKeyRequest,
            .remoteConnectionParameterRequest,
            .dataLengthChange,
            .readLocalP256PublicKeyComplete,
            .generateDHKeyComplete,
            .enhancedConnectionComplete,
            .directedAdvertisingReport,
            .phyUpdateComplete,
            .extendedAdvertisingReport,
            .periodicAdvertisingSyncEstablished,
            .periodicAdvertisingReport,
            .periodicAdvertisingSyncLost,
            .extendedScanTimeout,
            .extendedAdvertisingSetTerminated,
            .scanRequestReceived,
            .channelSelectionAlgorithm
        ]
        
        public var event: LowEnergyEvent {
            
            switch self {
                
            case .connectionComplete: return .connectionComplete
            case .advertisingReport: return .advertisingReport
            case .connectionUpdateComplete: return .connectionUpdateComplete
            case .readRemoteFeaturesComplete: return .readRemoteUsedFeaturesComplete
            case .longTermKeyRequest: return .longTermKeyRequest
            case .remoteConnectionParameterRequest: return .remoteConnectionParameterRequest
            case .dataLengthChange: return .dataLengthChange
            case .readLocalP256PublicKeyComplete: return .readLocalP256PublicKeyComplete
            case .generateDHKeyComplete: return .generateDHKeyComplete
            case .enhancedConnectionComplete: return .enhancedConnectionComplete
            case .directedAdvertisingReport: return .directedAdvertisingReport
            case .phyUpdateComplete: return .phyUpdateComplete
            case .extendedAdvertisingReport: return .extendedAdvertisingReport
            case .periodicAdvertisingSyncEstablished: return .periodicAdvertisingSyncEstablished
            case .periodicAdvertisingReport: return .periodicAdvertisingReport
            case .periodicAdvertisingSyncLost: return .periodicAdvertisingSyncLost
            case .extendedScanTimeout: return .scanTimeout
            case .extendedAdvertisingSetTerminated: return .advertisingSetTerminated
            case .scanRequestReceived: return .scanRequestReceived
            case .channelSelectionAlgorithm: return .channelSelectionAlgorithm
            }
        }
        
        public var description: String {
            
            return event.description
        }
    }
}
