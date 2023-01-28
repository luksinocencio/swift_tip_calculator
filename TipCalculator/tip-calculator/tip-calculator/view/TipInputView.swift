import UIKit

class TipInputView: UIView {
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func layout() {
        backgroundColor = .red
    }
}
