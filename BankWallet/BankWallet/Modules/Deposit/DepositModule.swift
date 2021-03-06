import Foundation

protocol IDepositView: class {
    func showCopied()
}

protocol IDepositViewDelegate {
    func addressItems(forCoin coinCode: CoinCode?) -> [AddressItem]
    func onCopy(addressItem: AddressItem)
}

protocol IDepositInteractor {
    func wallets(forCoin coinCode: CoinCode?) -> [Wallet]
    func copy(address: String)
}

protocol IDepositInteractorDelegate: class {
}

protocol IDepositRouter {
}
