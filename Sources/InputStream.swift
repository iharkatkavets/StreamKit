//
// MIT License
//
// Copyright (c) 2023 Ihar Katkavets

// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

public protocol InputStream {
    var hasBytesAvailable: Bool { get }
    
    func open() throws
    func read(_ toBuffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int
    func close()
}

public extension InputStream {
    func readToEnd(_ chunkLen: Int = 1<<15) throws -> Data {
        var result = Data()
        var tmpBuffer = Array<UInt8>(repeating: 0, count: chunkLen)
        while hasBytesAvailable {
            let readLen = try read(&tmpBuffer, maxLength: chunkLen)
            result.append(&tmpBuffer, count: readLen)
        }
        return result
    }
}