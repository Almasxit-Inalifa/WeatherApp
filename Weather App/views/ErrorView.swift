import UIKit

class ErrorView: UIView {
    let message: String
    
    init(width: CGFloat, message: String) {
        self.message = message
        super.init(frame: .zero)
        
        self.frame.size = CGSize(width: width, height: 80)
        backgroundColor = ERROR_BACKGROUND
        layer.cornerRadius = 10
        alpha = 0.95
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let title = CustomLabel(text: "Error Occurred", fontSize: 14, color: .white, fontWeight: .bold)
        
        let label = CustomLabel(text: self.message, fontSize: 12, color: .white)
        label.numberOfLines = 0
        
        let vStack = UIStackView(arrangedSubviews: [title, label])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .equalSpacing
        vStack.spacing = 8
        vStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
}
