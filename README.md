# StreamKit
The set of ciphers written on Swift. The ciphers can be orginized into the groups, where the output of fist stream can be the input of the another stream etc

For example it's possible to encrypt some data and simulteniously write the encrypted result to a file. 
```swift
let secureFileURL: URL = ...
let fileHandle = try! FileHandle(forWritingTo: secureFileURL)
let outputFileStream = FileOutputStream(with: fileHandle)
try outputFileStream.open()
        
let encryptingStream = Salsa20OutputStream(writingTo: outputFileStream,
                                            key: key,
                                            iv: iv)
try encryptingStream.open()
                
let tmpBufferLen = 1<<16 
var tmpBuffer = Array<UInt8>(repeating: 0, count: tmpBufferLen)
while inputFileStream.hasBytesAvailable {
  let readLen = inputFileStream.read(&tmpBuffer, maxLength: tmpBufferLen)
  try encryptingStream.write(tmpBuffer, length: readLen)
}
        
try encryptingStream.close()
try outputFileStream.close()
```

Another example demonstrate reading the encrypted file 
```swift
let inputFileStream = FileInputStream(withFileHandle: try! FileHandle(forReadingFrom: secureFileURL))
try inputFileStream.open()
        
let bufferingStream = BufferOutputStream()
try bufferingStream.open()
        
let decryptingStream = Salsa20InputStream(readingFrom: inputFileStream,
                                                  key: key,
                                                  iv: iv)
try decryptingStream.open()
        
let tmpBufferLen = 1<<16 // 65KB buffer
var tmpBuffer = Array<UInt8>(repeating: 0, count: tmpBufferLen)
while decryptingStream.hasBytesAvailable {
  let readLen = try decryptingStream.read(&tmpBuffer, maxLength: tmpBufferLen)
  try bufferingStream.write(tmpBuffer, length: readLen)
}
        
decryptingStream.close()
try bufferingStream.close()
inputFileStream.close()

```


### Sponsored by [KeePassium](https://github.com/keepassium)
