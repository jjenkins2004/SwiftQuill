//
//  File.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/19/25.
//

import Foundation

extension QuillDoc {
    func getRawString() -> String {
        return ops.compactMap { $0.insert }.joined()
    }
}
