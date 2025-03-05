import UIKit

class ErrorPopupManager {
    static func showErrorPopup(on view: UIView, message: String, width: CGFloat, yOffset: CGFloat) {
        let errorView = ErrorView(width: width, message: message)
        view.addSubview(errorView)

        let navBarHeight = view.safeAreaInsets.top
        let yOffset = navBarHeight + yOffset
        
        errorView.frame = CGRect(x: (view.frame.width - width) / 2, y: -80, width: width, height: 70)

        UIView.animate(withDuration: 0.5, animations: {
            errorView.frame.origin.y = yOffset
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.animate(withDuration: 0.5, animations: {
                    errorView.frame.origin.y = -80
                }) { _ in
                    errorView.removeFromSuperview()
                }
            }
        }
    }
}
