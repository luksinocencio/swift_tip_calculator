import Foundation

extension Double {
    var currencyFormatted: String {
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false: self == rounded()
        }
        
        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
//        formatter.currencySymbol = "R$"
        return formatter.string(for: self) ?? ""
    }
}
