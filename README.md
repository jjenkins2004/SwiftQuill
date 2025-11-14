# SwiftQuill

SwiftQuill is a lightweight, native Swift library for parsing and converting [Quill](https://quilljs.com/) Deltas. It provides a simple data model to convert between the Quill JSON format and `NSAttributedString` for use in UIKit applications.

This is an initial release focused on core text formatting. Support is currently limited to **`insert` operations only**.

The only attributes supported are:
* **bold**
* **italic**
* **underline**

Operations such as `delete` and `retain`, as well as other attribute types (like links, headers, or lists), are **not supported** in this version.

## Usage Example

Initialize the `SwiftQuill` class with a base font size. This class is the main entry point for all conversions.

```swift
import SwiftQuill
import UIKit

// 1. Initialize the converter
let quill = SwiftQuill(fontSize: 18)

// 2. Create your data model
let delta1 = TextDelta(insert: "Hello", attributes: [.bold: true])
let delta2 = TextDelta(insert: " World", attributes: [.italic: true, .underline: true])
let doc = QuillDoc(deltas: [delta1, delta2])

// --- Doc -> NSAttributedString ---
// Convert your QuillDoc into an NSAttributedString for display

let attributedString = quill.convertToAttributed(doc)
// 'attributedString' can now be set on a UILabel or UITextView.


// --- NSAttributedString -> Doc ---
// Convert an NSAttributedString back into your QuillDoc model

do {
    let resultingDoc = try quill.convertToQuill(attributedString)
    // 'resultingDoc' is now equal to 'doc'
} catch {
    print("Error parsing NSAttributedString: \(error)")
}


// --- JSON Serialization ---

// Encode a QuillDoc to JSON Data
do {
    let jsonData = try quill.encodeQuill(doc)
    // jsonData is now {"ops":[{"attributes":{"bold":true},"insert":"Hello"},...]}
    
    // Decode JSON Data back to a QuillDoc
    let decodedDoc = try quill.decodeQuill(jsonData)
    // 'decodedDoc' is now equal to 'doc'
} catch {
    print("Error encoding or decoding JSON: \(error)")
}
