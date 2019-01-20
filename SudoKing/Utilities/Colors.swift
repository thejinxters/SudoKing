import Cocoa

class Colors {
    static let Green = rgbColor(red: 14, green: 97, blue: 99, alpha: 1.0)
    static let LessGreen = rgbColor(red: 14, green: 55, blue: 55, alpha: 1.0)

    
    
    private static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> NSColor {
        return NSColor(
            calibratedRed: red/255,
            green: green/255,
            blue: blue/255,
            alpha: alpha
        )
    }
}
