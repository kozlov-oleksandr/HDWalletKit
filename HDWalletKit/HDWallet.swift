public final class HDWallet {
    
    private let masterPrivateKey: HDPrivateKey
    private let network: Network
    
    public init(seed: Data, network: Network) {
        self.masterPrivateKey = HDPrivateKey(seed: seed, network: network)
        self.network = network
    }
    
    public func generatePrivateKey(at indexes: [(UInt32, Bool)]) throws -> HDPrivateKey {
        return try privateKey(at: indexes)
    }
    
    private func privateKey(at indexes: [(index: UInt32, hardens: Bool)]) throws -> HDPrivateKey {
        var key: HDPrivateKey = try masterPrivateKey.derived(at: indexes.first!.index, hardens: indexes.first!.hardens)
        for i in indexes.dropFirst(){
            key = try key.derived(at: i.index, hardens: i.hardens)
        }
        
        return key
    }
}
