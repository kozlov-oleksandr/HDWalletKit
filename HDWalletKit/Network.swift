public struct Hardens {
    public static let HARDENED = true
    public static let NOT_HARDENED = false
}

public enum Coin {
    case bitcoin
    case litecoin
    case nem
    case ethereum
    case ethereumClassic
    case monero
    case zcash
    case lisk
    case bitcoinCash
}

public enum Network {
    case main(Coin)
    case test

    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    public var coinType: UInt32 {
        switch self {
        case .main(let coin):
            switch coin {
            case .bitcoin:
                return 0
            case .litecoin:
                return 2
            case .nem:
                return 43
            case .ethereum:
                return 60
            case .ethereumClassic:
                return 61
            case .monero:
                return 128
            case .zcash:
                return 133
            case .lisk:
                return 134
            case .bitcoinCash:
                return 145
            }
            
        case .test:
            return 1
        }
    }

    public var privateKeyPrefix: UInt32 {
        switch self {
        case .main:
            return 0x0488ADE4
        case .test:
            return 0x04358394
        }
    }
    
    public var publicKeyPrefix: UInt32 {
        switch self {
        case .main:
            return 0x0488b21e
        case .test:
            return 0x043587cf
        }
    }
}
