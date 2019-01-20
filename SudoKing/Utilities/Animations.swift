import Foundation
import Cocoa

class Animations {
    static func shake(view: NSView, distance: CGFloat, repeatCount: Float, duration: Double) {
        view.wantsLayer = true
        let midX = view.frame.origin.x
        let midY = view.frame.origin.y
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - distance, y: midY)
        animation.toValue = CGPoint(x: midX + distance, y: midY)
        view.layer?.add(animation, forKey: "position")
    }
}
