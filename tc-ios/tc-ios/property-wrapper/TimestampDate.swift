//
//  TimestampDate.swift
//  test-swiftui
//
//  Created by LIUWEI on 2024/11/30.
//

import Foundation

@propertyWrapper
struct TimestampDate: Codable {
    var wrappedValue: Date
    
    init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Int64.self)
        wrappedValue = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let timestamp = Int64(wrappedValue.timeIntervalSince1970 * 1000)
        try container.encode(timestamp)
    }
}


@propertyWrapper
struct OptionalTimestampDate: Codable {
    var wrappedValue: Date?
    
    init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            wrappedValue = nil
        } else {
            let timestamp = try container.decode(Int64.self)
            wrappedValue = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = wrappedValue {
            let timestamp = Int64(date.timeIntervalSince1970 * 1000)
            try container.encode(timestamp)
        } else {
            try container.encodeNil()
        }
    }
}
