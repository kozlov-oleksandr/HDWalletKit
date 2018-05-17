//
//  ViewController.swift
//  Example
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import UIKit
import HDWalletKit
import CryptoSwift


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let mnemonic = Mnemonic.create()
        let mnemonic = ["captain","select","poverty","zoo","accident","sort","dream","hollow","jazz","sort","always","marriage"]
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = HDWallet(seed: seed, network: .main(.ethereum))
        
        do {
            let privateKey = try wallet.generatePrivateKey(at: [(44, Hardens.HARDENED),
                                                                    (Network.main(.ethereum).coinType, Hardens.HARDENED),
                                                                    (0, Hardens.HARDENED),
                                                                    (0, Hardens.NOT_HARDENED),
                                                                    (0, Hardens.NOT_HARDENED)])
            print("PrivKey: \(privateKey.get())")
            let pubKey = privateKey.hdPublicKey()
            print("Pubkey:  \(pubKey.get())")
            print("Addr:    \(pubKey.address())")
            
            
        } catch let error {
            print("Error: \(error)")
        }
    }
}
