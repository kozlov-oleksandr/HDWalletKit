//
//  ViewController.swift
//  Example
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import UIKit
import HDWalletKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mnemonic = Mnemonic.create()
        
        // nuclear you cage screen tribe trick limb smart dad voice nut jealous
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = HDWallet(seed: seed, network: .main(.bitcoin))
        
        do {
            let extPrivateKey = try wallet.generatePrivateKey(at: [(44, true) ,(0, true), (0, true), (0,false),(0,false)])
            print(extPrivateKey.extended())
            
            let publicKey = extPrivateKey.hdPublicKey()
            print(publicKey.raw.toHexString())
            
        } catch let error {
            print("Error: \(error)")
        }
    }
}
