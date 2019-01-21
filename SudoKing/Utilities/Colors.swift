import Cocoa

class Colors {
    static let LightTeal = rgbColor(red: 14, green: 100, blue: 100, alpha: 1.0)
    static let DarkTeal = rgbColor(red: 14, green: 55, blue: 55, alpha: 1.0)
    static let VeryDarkTeal = rgbColor(red: 14, green: 45, blue: 45, alpha: 1.0)
    
    private static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> NSColor {
        return NSColor(
            calibratedRed: red/255,
            green: green/255,
            blue: blue/255,
            alpha: alpha
        )
    }
}
