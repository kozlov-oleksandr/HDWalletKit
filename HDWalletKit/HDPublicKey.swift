import CryptoSwift

public struct HDPublicKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let childIndex: UInt32
    private let network: Network

    private let hdPrivateKey: HDPrivateKey

    public init(hdPrivateKey: HDPrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, childIndex: UInt32) {
        self.raw = Crypto.generatePublicKey(data: hdPrivateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.childIndex = childIndex
        self.network = network
        self.hdPrivateKey = hdPrivateKey
    }
    
    public func extended() -> String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyPrefix.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += childIndex.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        let checksum = Crypto.doubleSHA256(extendedPublicKeyData).prefix(4)
        return Base58.encode(extendedPublicKeyData + checksum)
    }
    
    private func btc_adress() -> String {
        var data = Data()
        data += UInt8(0x00)
        data += CryptoHash.ripemd160(raw.sha256())
        data += Crypto.doubleSHA256(data).prefix(4)
        return Base58.encode(data)
    }
    
    private func eth_adress() -> String {
        let keccak256: SHA3 = SHA3(variant: CryptoSwift.SHA3.Variant.keccak256)
        let hash = keccak256.calculate(for: Crypto.decompressPubKey(data: self.raw).dropFirst().bytes)
        let index = hash.toHexString().index(hash.toHexString().startIndex, offsetBy: 24)
        let addr: String = String(hash.toHexString()[index..<hash.toHexString().endIndex])
        return addr
    }
    
    public func get() -> String {
        return self.raw.toHexString()
    }
    public func address() -> String {
        switch self.network.coinType {
        case Network.main(.bitcoin).coinType:
            return btc_adress()
        case Network.main(.ethereum).coinType:
            return eth_adress()
        default:
            return "None"
        }
    }
    
}
