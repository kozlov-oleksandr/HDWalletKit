public struct HDPrivateKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let childIndex: UInt32
    private let network: Network

    public init(seed: Data, network: Network) {
        let output = Crypto.HMACSHA512(key: "Bitcoin seed".data(using: .ascii)!, data: seed)
        self.raw = output[0..<32]
        self.chainCode = output[32..<64]
        self.depth = 0
        self.fingerprint = 0
        self.childIndex = 0
        self.network = network
    }

    private init(hdPrivateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.raw = hdPrivateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.childIndex = index
        self.network = network
    }

    public func hdPublicKey() -> HDPublicKey {
        return HDPublicKey(hdPrivateKey: self, chainCode: chainCode, network: network, depth: depth, fingerprint: fingerprint, childIndex: childIndex)
    }

    public func extended() -> String {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyPrefix.bigEndian
        extendedPrivateKeyData += depth.littleEndian
        extendedPrivateKeyData += fingerprint.littleEndian
        extendedPrivateKeyData += childIndex.littleEndian
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0)
        extendedPrivateKeyData += raw
        let checksum = Crypto.doubleSHA256(extendedPrivateKeyData).prefix(4)
        return Base58.encode(extendedPrivateKeyData + checksum)
    }
    
    public func wif() -> String {
        if self.network.coinType == Network.main(.bitcoin).coinType {
            var data = Data()
            data += UInt8(0x80)
            data += raw
            data += UInt8(0x01)
            data += Crypto.doubleSHA256(data).prefix(4)
            return Base58.encode(data)
        }
        return "WIF is not specified"
    }
    
    public func get() -> String {
        switch self.network.coinType {
        case Network.main(.bitcoin).coinType:
            return self.wif()
        case Network.main(.ethereum).coinType:
            return self.raw.toHexString()
        default:
            return "None"
        }
    }

    internal func derived(at index: UInt32, hardens: Bool = false) throws -> HDPrivateKey {
        guard (0x80000000 & index) == 0 else {
            fatalError("Invalid index \(index)")
        }

        let keyDeriver = KeyDerivation(
            privateKey: raw,
            publicKey: hdPublicKey().raw,
            chainCode: chainCode,
            depth: depth,
            fingerprint: fingerprint,
            childIndex: childIndex
        )

        guard let derivedKey = keyDeriver.derived(at: index, hardened: hardens) else {
            throw HDWalletKitError.keyDerivateionFailed
        }

        return HDPrivateKey(
            hdPrivateKey: derivedKey.privateKey!,
            chainCode: derivedKey.chainCode,
            depth: derivedKey.depth,
            fingerprint: derivedKey.fingerprint,
            index: derivedKey.childIndex,
            network: network
        )
    }
}
