import XCTest

class CalculatorScreen {
    private let app: XCUIApplication!
    
    init(app: XCUIApplication!) {
        self.app = app
    }
    
    // MARK: - LogoView
    
    var logoView: XCUIElement {
        app.otherElements[ScreenIdentifier.LogoView.logoView.rawValue]
    }
    
    // MARK: - ResultView
    
    var totalAmountPerPersonalValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue]
    }
    
    var totalBillValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalBillValueLabel.rawValue]
    }
    
    var totalTipValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.ResultView.totalTipValueLabel.rawValue]
    }
    
    // MARK: - BillInputView
    
    var billInputViewTextField: XCUIElement {
        app.textFields[ScreenIdentifier.BillInputView.textField.rawValue]
    }
    
    // MARK: - TipInputView
    
    var tenPercentTipButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.tenPercentButton.rawValue]
    }
    
    var fifteenPercentTipButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.fifteenPercentButton.rawValue]
    }
    
    var twentyPercentTipButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.twentyPercentButton.rawValue]
    }
    
    var customTipButton: XCUIElement {
        app.buttons[ScreenIdentifier.TipInputView.customTipButton.rawValue]
    }
    
    var customTipAlertTextField: XCUIElement {
        app.textFields[ScreenIdentifier.TipInputView.customTipAlertTextField.rawValue]
    }
    
    // MARK: - SplitView
    
    var incrementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.incrementButton.rawValue]
    }
    
    var decrementButton: XCUIElement {
        app.buttons[ScreenIdentifier.SplitInputView.decrementButton.rawValue]
    }
    
    var quantityValueLabel: XCUIElement {
        app.staticTexts[ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue]
    }
    
    // MARK: - Actions
    
    func enterBill(amount: Double) {
        billInputViewTextField.tap()
        billInputViewTextField.typeText("\(amount)\n")
    }
    
    func selectTip(tip: Tip) {
        switch tip {
            case .tenPercent:
                tenPercentTipButton.tap()
            case .fifteenPercent:
                fifteenPercentTipButton.tap()
            case .twentyPercent:
                twentyPercentTipButton.tap()
            case .custom(let value):
                customTipButton.tap()
                XCTAssertTrue(customTipAlertTextField.waitForExistence(timeout: 1.0))
                customTipAlertTextField.typeText("\(value)")
        }
    }
    
    func selectIncrementButton(numberOfTaps: Int) {
        incrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func selectDecrementButton(numberOfTaps: Int) {
        decrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func doubleTapLogoView() {
        logoView.tap(withNumberOfTaps: 2, numberOfTouches: 1)
    }
    
    enum Tip {
        case tenPercent
        case fifteenPercent
        case twentyPercent
        case custom(value: Int)
    }
}
