import UIKit

class CustomLabel: UILabel {
    init(text: String = "", fontSize: CGFloat = 16, color: UIColor, fontWeight: UIFont.Weight = .semibold) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
