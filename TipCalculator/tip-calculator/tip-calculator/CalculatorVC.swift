import Combine
import CombineCocoa
import SnapKit
import UIKit

class CalculatorVC: UIViewController {
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        
        return stackView
    }()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher
        )
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
    }
    
    func observe() {
        viewTapPublisher.sink { [unowned self] value in
            view.endEditing(true)
        }.store(in: &cancellables)
        
        logoViewTapPublisher.sink { [unowned self] value in
            print("logo view taooed")
        }.store(in: &cancellables)
    }
    
    private func layout() {
        setup()
        setupVStackView()
        setupLogoView()
        setupResultView()
        setupBillInputView()
        setupTipInputView()
        setupSplitView()
    }
    
    private func setup() {
        view.backgroundColor = ThemeColor.bg
    }
    
    private func setupVStackView() {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leadingMargin).offset(16)
            $0.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            $0.top.equalTo(view.snp.topMargin).offset(16)
        }
    }
    
    private func setupLogoView() {
        logoView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    private func setupResultView() {
        resultView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
    }
    
    private func setupBillInputView() {
        billInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
    
    private func setupTipInputView() {
        tipInputView.snp.makeConstraints {
            $0.height.equalTo(56+56+15)
        }
    }
    
    private func setupSplitView() {
        splitInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
}

