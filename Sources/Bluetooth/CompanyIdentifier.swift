//
//  CompanyID.swift
//  Bluetooth
//
//  Created by Alsey Coleman Miller on 11/28/17.
//  Copyright © 2017 PureSwift. All rights reserved.
//

/// Company identifiers are unique numbers assigned by the Bluetooth SIG to member companies requesting one.
///
/// Each Bluetooth SIG member assigned a Company Identifier may use the assigned value for any/all of the following:
///
/// * LMP_CompID (refer to the Bluetooth® Core Specification)
/// * Company Identifier Code used in Manufacturer Specific Data type used for EIR and Advertising Data Types (refer to CSSv1 or later)
/// * Company ID for vendor specific codecs (refer to Vol. 2, Part E, of the Bluetooth Core Specification, v4.1 or later)
/// * As the lower 16 bits of the Vendor ID for designating Vendor Specific A2DP Codecs (refer to the A2DP v1.3 or later
/// * VendorID Attribute in Device ID service record (when VendorIDSourceAttribute equals 0x0001, refer toDevice ID Profile)
/// * 802.11_PAL_Company_Identifier (refer to Bluetooth Core Specification v3.0 + HS or later)
/// * TCS Company ID (refer to Telephony Control Protocol [[WITHDRAWN](https://www.bluetooth.com/specifications)])
///
/// Each of the adopted specifications listed above can be found on the [Adopted Specifications Page](https://www.bluetooth.com/specifications)
/// unless it is otherwise indicated as withdrawn.
///
/// - SeeAlso: [Company Identifiers](https://www.bluetooth.com/specifications/assigned-numbers/company-identifiers)
@frozen
public struct CompanyIdentifier: RawRepresentable, Equatable, Hashable, Sendable {
    
    public var rawValue: UInt16
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
}

#if !os(WASI)
public extension CompanyIdentifier {
    
    /// Bluetooth Company name.
    ///
    /// - SeeAlso: [Company Identifiers](https://www.bluetooth.com/specifications/assigned-numbers/company-identifiers)
    var name: String? {
        return Self.companyIdentifiers[rawValue]
    }
}
#endif

// MARK: - ExpressibleByIntegerLiteral

extension CompanyIdentifier: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt16) {
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension CompanyIdentifier: CustomStringConvertible {
    
    public var description: String {
        #if os(WASI)
        return rawValue.description
        #else
        return name ?? rawValue.description
        #endif
    }
}
