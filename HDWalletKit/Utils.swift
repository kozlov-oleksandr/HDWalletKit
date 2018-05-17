//
//  Utils.swift
//  HDWalletKit
//
//  Created by Binomial on 16.05.2018.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

public func hexadecimal(_ str: String) -> Data {
    var data = Data(capacity: str.count / 2)
    
    let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
    regex.enumerateMatches(in: str, range: NSMakeRange(0, str.utf16.count)) { match, flags, stop in
        let byteString = (str as NSString).substring(with: match!.range)
        var num = UInt8(byteString, radix: 16)!
        data.append(&num, count: 1)
    }
    
    return data
}
