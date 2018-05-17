#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CryptoHash : NSObject
+ (NSData *)hmacsha512:(NSData *)data key:(NSData *)key;
+ (NSData *)ripemd160:(NSData *)data;
@end

@interface PKCS5 : NSObject
+ (NSData *)PBKDF2:(NSData *)password salt:(NSData *)salt iterations:(NSInteger)iterations keyLength:(NSInteger)keyLength;
@end

@interface Secp256k1 : NSObject
+ (NSData *)getUncompressedPubKeyWithKey:(NSData *)pub_key;
+ (NSData *)generatePublicKeyWithPrivateKey:(NSData *)privateKeyData compression:(BOOL)isCompression;
@end

@interface KeyDerivation : NSObject
@property (nonatomic, readonly, nullable) NSData *privateKey;
@property (nonatomic, readonly, nullable) NSData *publicKey;
@property (nonatomic, readonly) NSData *chainCode;
@property (nonatomic, readonly) uint8_t depth;
@property (nonatomic, readonly) uint32_t fingerprint;
@property (nonatomic, readonly) uint32_t childIndex;

- (instancetype)initWithPrivateKey:(nullable NSData *)privateKey publicKey:(nullable NSData *)publicKey chainCode:(NSData *)chainCode depth:(uint8_t)depth fingerprint:(uint32_t)fingerprint childIndex:(uint32_t)childIndex;
- (nullable KeyDerivation *)derivedAtIndex:(uint32_t)childIndex hardened:(BOOL)hardened;

@end
NS_ASSUME_NONNULL_END
