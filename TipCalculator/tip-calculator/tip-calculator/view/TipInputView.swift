import Combine
import UIKit

class TipInputView: UIView {
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipbutton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.tenPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(Tip.tenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var fifteenPercentTipbutton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(Tip.fifteenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipbutton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.twentyPercentButton.rawValue
        button.tapPublisher.flatMap({
            Just(Tip.twentyPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = ScreenIdentifier.TipInputView.customTipButton.rawValue
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink { [weak self] in
            self?.handleCustomTipButton()
        }.store(in: &cancellables)
        
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipbutton,
            fifteenPercentTipbutton,
            twentyPercentTipbutton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    
    var valuePublisher: AnyPublisher<Tip, Never> {
        tipSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func reset() {
        tipSubject.send(.none)
    }
    
    private func layout() {
        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        buttonVStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            $0.width.equalTo(68)
            $0.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(title: "Enter custom tip", message: nil, preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
                textField.accessibilityIdentifier = ScreenIdentifier.TipInputView.customTipAlertTextField.rawValue
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let text = controller.textFields?.first?.text,
                      let value = Int(text) else { return }
                self?.tipSubject.send(.custom(value: value))
            }
            [okAction, cancelAction].forEach(controller.addAction(_:))
            
            return controller
        }()
        
        parentViewController?.present(alertController, animated: true)
    }
    
    private func resetView() {
        [
            tenPercentTipbutton,
            fifteenPercentTipbutton,
            twentyPercentTipbutton,
            customTipButton
        ].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)]
        )
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            
            resetView()
            
            switch tip {
                case .none:
                    break
                case .tenPercent:
                    tenPercentTipbutton.backgroundColor = ThemeColor.secondary
                case .fifteenPercent:
                    fifteenPercentTipbutton.backgroundColor = ThemeColor.secondary
                case .twentyPercent:
                    twentyPercentTipbutton.backgroundColor = ThemeColor.secondary
                case .custom(let value):
                    customTipButton.backgroundColor = ThemeColor.secondary
                    let text = NSMutableAttributedString(
                        string: "$\(value)",
                        attributes: [
                            .font: ThemeFont.bold(ofSize: 20)
                        ]
                    )
                    
                    text.addAttributes([
                        .font: ThemeFont.bold(ofSize: 14)
                    ], range: NSMakeRange(0, 1))
                    customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.titleLabel?.textColor = .white
        
        let text = NSMutableAttributedString(string: tip.stringValue, attributes: [
            .font: ThemeFont.bold(ofSize: 20)
        ])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        
        return button
    }
}
