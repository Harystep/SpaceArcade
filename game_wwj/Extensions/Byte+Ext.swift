//
//  Byte+Ext.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

extension Data {
    var unsafeRawBufferPointer: UnsafeRawBufferPointer {
        return self.withUnsafeBytes { $0 }
    }
    var unsafeRawPointer: UnsafeRawPointer {
        let nsData = self as NSData;
        return nsData.bytes;
    }
    
    var unsafeMutableRowBufferPointer: UnsafeMutableRawBufferPointer {
        var data = self;
        return data.withUnsafeMutableBytes { $0 }
    }
    var unsafeBufferPointer_UInt8: UnsafeBufferPointer<UInt8> {
        return self.withContiguousStorageIfAvailable { $0 }!
    }
    var UnsafeMutableBufferPointer_UInt8: UnsafeMutableBufferPointer<UInt8>? {
        var data = self
        return data.withContiguousMutableStorageIfAvailable { $0 }
    }
    
    //1bytes转Int
    func lyz_1BytesToInt() -> Int {
        var value : UInt8 = 0
        let data = NSData(bytes: [UInt8](self), length: self.count)
        data.getBytes(&value, length: self.count)
        value = UInt8(bigEndian: value)
        return Int(value)
    }
    //2bytes转Int
    func lyz_2BytesToInt() -> Int {
        var value : UInt16 = 0
        let data = NSData(bytes: [UInt8](self), length: self.count)
        data.getBytes(&value, length: self.count)
        value = UInt16(bigEndian: value)
        return Int(value)
    }
    //4bytes转Int
    func lyz_4BytesToInt() -> Int {
        var value : UInt32 = 0
        let data = NSData(bytes: [UInt8](self), length: self.count)
        data.getBytes(&value, length: self.count)
        value = UInt32(bigEndian: value)
        return Int(value)
    }
}

extension String {
    var unsafePointer: UnsafePointer<Int8> {
        return self.withCString { $0 }
    }
    
    var unsafeBufferPointer: UnsafeBufferPointer<UInt8> {
        var tmpStr = self
        return tmpStr.withUTF8 { $0 }
    }
}
