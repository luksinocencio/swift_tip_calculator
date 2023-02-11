import XCTest

final class tip_calculatorUITests: XCTestCase {
    private var app: XCUIApplication!
    private var screen: CalculatorScreen {
        CalculatorScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
    }
    
    func testRegularTip() {
        // User enters a $100 bill
        screen.enterBill(amount: 100)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$100")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$100")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        
        // User selects 10%
        screen.selectTip(tip: .tenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$110")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$110")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$10")
        
        // User selects 15%
        screen.selectTip(tip: .fifteenPercent)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$115")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$115")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$15")
        
        // User selects 20%
        screen.selectTip(tip: .twentyPercent)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$120")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
        
        // User split the bill by 4
        screen.selectIncrementButton(numberOfTaps: 3)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$30")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
        
        // User split the bill by 2
        screen.selectDecrementButton(numberOfTaps: 2)
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$60")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$120")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$20")
    }
    
    func testCustomTipAndSplitBillBy2() {
        screen.enterBill(amount: 300)
        screen.selectTip(tip: .custom(value: 200))
        screen.selectIncrementButton(numberOfTaps: 1)
        XCTAssertEqual(screen.totalBillValueLabel.label, "$300")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$150")
    }
    
    func testResetButton() {
        screen.enterBill(amount: 300)
        screen.selectTip(tip: .custom(value: 200))
        screen.selectIncrementButton(numberOfTaps: 1)
        screen.doubleTapLogoView()
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        XCTAssertEqual(screen.totalAmountPerPersonalValueLabel.label, "$0")
        XCTAssertEqual(screen.billInputViewTextField.label, "")
        XCTAssertEqual(screen.quantityValueLabel.label, "1")
        XCTAssertEqual(screen.customTipButton.label, "Custom tip")
    }
}
