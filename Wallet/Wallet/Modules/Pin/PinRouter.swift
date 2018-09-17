import UIKit

class PinRouter {
    weak var viewController: UIViewController?
}

extension PinRouter: IPinRouter {

    func onSet(pin: String) {
        viewController?.navigationController?.pushViewController(PinRouter.confirmPinModule(pin: pin), animated: true)
    }

    func onConfirm() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }

    func onUnlock() {
        viewController?.dismiss(animated: true)
    }

}

extension PinRouter {

    static func setPinModule() -> UIViewController {
        let router = PinRouter()
        let interactor = SetPinInteractor()
        let presenter = SetPinPresenter(interactor: interactor, router: router)
        let viewController = PinViewController(viewDelegate: presenter)

        interactor.delegate = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

    static func confirmPinModule(pin: String) -> UIViewController {
        let router = PinRouter()
        let interactor = ConfirmPinInteractor(pin: pin)
        let presenter = ConfirmPinPresenter(interactor: interactor, router: router)
        let viewController = PinViewController(viewDelegate: presenter)

        interactor.delegate = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

    static func editPinModule() -> UIViewController {
        let router = PinRouter()
        let interactor = NewPinInteractor()
        let presenter = NewPinPresenter(interactor: interactor, router: router)
        let viewController = PinViewController(viewDelegate: presenter)

        interactor.delegate = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

    static func unlockPinModule(title: String?, description: String, pin: String, onUnlock: (() -> ())? = nil) -> UIViewController {
        let router = PinRouter()
        let interactor = UnlockPinInteractor(unlockHelper: UnlockHelper.shared)
        let presenter = UnlockPinPresenter(interactor: interactor, router: router)
        let viewController = PinViewController(viewDelegate: presenter)

        interactor.delegate = presenter
        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }

}
