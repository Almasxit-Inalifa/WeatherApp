import UIKit

class GradientBackgroundView: UIView {
    private let mainColor: UIColor
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect, mainColor: UIColor) {
        self.mainColor = mainColor
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        self.mainColor = UIColor.blue 
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            lighten(color: mainColor, percentage: 50).cgColor,
            lighten(color: mainColor, percentage: 10).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.cornerRadius = 20
        self.gradientLayer = gradientLayer
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds // Update gradient layer's frame
    }

    private func lighten(color: UIColor, percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let factor = min(max(percentage, 0), 100) / 100
        return UIColor(
            red: red + (1.0 - red) * factor,
            green: green + (1.0 - green) * factor,
            blue: blue + (1.0 - blue) * factor,
            alpha: 1.0
        )
    }
}
