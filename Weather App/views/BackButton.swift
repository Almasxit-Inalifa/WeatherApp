import UIKit

protocol BackButtonHandler: AnyObject {
    func didTapBackButton()
}

extension BackButtonHandler where Self: UIViewController {
    func didTapBackButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


class BackButton: UIBarButtonItem {
    weak var handler: BackButtonHandler?

    init(handler: BackButtonHandler) {
        super.init()
        self.handler = handler
        self.image = UIImage(systemName: "chevron.backward")
        self.style = .plain
        self.target = self
        self.action = #selector(backButtonTapped)
        self.tintColor = TINT_COLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonTapped() {
        handler?.didTapBackButton()
    }
}
