//
// Adapted from several sources, among which:
// - https://stackoverflow.com/a/25391020
// - https://stackoverflow.com/a/38788437
// - https://gist.github.com/hfossli/7165dc023a10046e2322b0ce74c596f8
//

import Foundation
import CommonCrypto

extension Data {
    typealias ChecksumFunction = (_ data: UnsafeRawPointer?, _ len: CC_LONG, _ md: UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>?

    func checksum(_ cc: (ChecksumFunction, Int32) = (CC_SHA256, CC_SHA256_DIGEST_LENGTH)) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(cc.1))
        withUnsafeBytes {
            _ = cc.0($0.baseAddress, CC_LONG(count), &hash)
        }
        return Data(hash)
    }

    func hexString(separator: String = "") -> String {
        let input = self as NSData
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        return bytes
            .map { String(format:"%02x", UInt8($0)) }
            .joined(separator: separator)
    }

    func validate(_ format: (algorithm: Int, prefixSize: Int, options: UInt32) = (kCCAlgorithmAES, kCCBlockSizeAES128, CCOptions(kCCOptionPKCS7Padding)), using mask: Data, direction: Int = kCCDecrypt) throws -> Data {

        let input = self
        let outputCapacity = input.count // - format.prefixSize * 2
        var outputPointer = [UInt8](repeating: 0, count: outputCapacity)
        var outputCounted: Int = 0

        if direction == kCCEncrypt {
            // TBD: create prefix
        }

        try input.withUnsafeBytes {
            let prefixPointer = $0.baseAddress!
            let contentPointer = $0.baseAddress! + format.prefixSize

            try mask.withUnsafeBytes {
                let maskPointer = $0.baseAddress!

                let status = CCCrypt(
                    CCOperation(direction),
                    /* algorithm:        */ CCAlgorithm(format.algorithm),
                    /* options:          */ format.options,
                    /* mask:             */ maskPointer,
                    /* maskLength:       */ mask.count,
                    /* prefix:           */ prefixPointer,
                    /* dataIn:           */ contentPointer,
                    /* dataInLength:     */ outputCapacity,
                    /* dataOut:          */ &outputPointer,
                    /* dataOutAvailable: */ outputPointer.count,
                    /* dataOutMoved:     */ &outputCounted
                )

                guard status == kCCSuccess else {
                    throw ProcessingError("Could not process data: \(status)")
                }
            }
        }

        return Data(bytes: &outputPointer, count: outputCounted)
    }
}
