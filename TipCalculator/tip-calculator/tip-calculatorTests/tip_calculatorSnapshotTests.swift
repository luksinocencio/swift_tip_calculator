import XCTest
import SnapshotTesting

@testable import tip_calculator

final class tip_calculatorSnapshotTests: XCTestCase {
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        // given
        let size = CGSize(width: screenWidth, height: 48)
        // when
        let view = LogoView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialResultView() {
        // given
        let size = CGSize(width: screenWidth, height: 224)
        // when
        let view = ResultView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testResultViewWithValues() {
        // given
        let size = CGSize(width: screenWidth, height: 224)
        let result = Result(amountPerPerson: 100.25, totalBill: 45, totalTip: 60)
        // when
        let view = ResultView()
        view.configure(result: result)
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialBillInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56)
        // when
        let view = BillInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialBillInputViewWithValues() {
        let size = CGSize(width: screenWidth, height: 56)
        
        let view = BillInputView()
        let textField = view.allSubViewsOf(type: UITextField.self).first
        textField?.text = "500"
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialTipInputView() {
        let size = CGSize(width: screenWidth, height: 56+56+16)
        let view = TipInputView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialTipInputViewWithValues() {
        // given
        let size = CGSize(width: screenWidth, height: 56+56+16)
        // when
        let view = TipInputView()
        let button = view.allSubViewsOf(type: UIButton.self).first
        button?.sendActions(for: .touchUpInside)
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testSplitInputView() {
        let size = CGSize(width: screenWidth, height: 56)
        let view = SplitInputView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testSplitInputViewWithSelection() {
        let size = CGSize(width: screenWidth, height: 56)
        
        let view = SplitInputView()
        let button = view.allSubViewsOf(type: UIButton.self).first
        button?.sendActions(for: .touchUpInside)
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
}

extension UIView {
    func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
