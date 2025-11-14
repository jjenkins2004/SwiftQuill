//
//  Extensions.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation

public extension TextDelta {
    internal enum CodingKeys: String, CodingKey {
        case insert
        case attributes
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(insert, forKey: .insert)

        if let attrs = attributes, !attrs.isEmpty {
            let convertedAttributes = Dictionary(uniqueKeysWithValues:
                attrs.map { key, value in (key.rawValue, value) })
            try container.encode(convertedAttributes, forKey: .attributes)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        insert = try container.decodeIfPresent(String.self, forKey: .insert)

        let rawAttributes = try container.decodeIfPresent([String: AttributeType].self, forKey: .attributes)

        if let rawAttributes = rawAttributes {
            let decodedAttributes = [Attributes: Bool](uniqueKeysWithValues:
                rawAttributes.compactMap { key, value in
                guard let attrKey = Attributes(rawValue: key), case let .bool(val) = value else {
                        return nil
                    }

                    return (attrKey, val)
                })
            attributes = decodedAttributes.isEmpty ? nil : decodedAttributes

        } else {
            attributes = nil
        }
    }
}
