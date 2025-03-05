import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        
        self.color = TINT_COLOR
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

