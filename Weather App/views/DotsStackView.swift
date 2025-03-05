import UIKit

class DotsStackView: UIStackView {
    
    private var dotColor: UIColor = .white
    private var selectedDotColor: UIColor = TINT_COLOR
    private var dotSize: CGFloat = 10
    private var currentIndex: Int = 0
    private var count: Int = 0

    init(count: Int, dotSize: CGFloat = 10, dotColor: UIColor = .white, selectedDotColor: UIColor = TINT_COLOR) {
        self.count = count
        self.dotSize = dotSize
        self.dotColor = dotColor
        self.selectedDotColor = selectedDotColor
        super.init(frame: .zero)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        axis = .horizontal
        alignment = .center
        distribution = .fillEqually
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false
        updateDots()
    }

    func updateDots(for index: Int = 0, count: Int? = nil) {
        if let newCount = count {
            self.count = newCount
        }
        currentIndex = index
        
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<self.count {
            let dot = UIView()
            dot.backgroundColor = i == currentIndex ? selectedDotColor : dotColor
            dot.layer.cornerRadius = dotSize / 2
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.heightAnchor.constraint(equalToConstant: dotSize).isActive = true
            dot.widthAnchor.constraint(equalToConstant: dotSize).isActive = true
            addArrangedSubview(dot)
        }
    }
}
