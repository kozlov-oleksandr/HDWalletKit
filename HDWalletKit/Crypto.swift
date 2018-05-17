import HDWalletKit.Private
import secp256k1

public final class Crypto {
    public static func HMACSHA512(key: Data, data: Data) -> Data {
        return CryptoHash.hmacsha512(data, key: key)
    }
    
    public static func Ripemd160(_ data: Data) -> Data {
        return CryptoHash.ripemd160(data)
    }

    public static func PBKDF2SHA512(_ password: Data, salt: Data) -> Data {
        return PKCS5.pbkdf2(password, salt: salt, iterations: 2048, keyLength: 64)
    }
    
    public static func doubleSHA256(_ data: Data) -> Data {
        return data.sha256().sha256()
    }

    public static func generatePublicKey(data: Data, compressed: Bool) -> Data {
        return Secp256k1.generatePublicKey(withPrivateKey: data, compression: compressed)
    }
    
    public static func decompressPubKey(data: Data) -> Data {
        return Secp256k1.getUncompressedPubKey(withKey: data)
    }
}
