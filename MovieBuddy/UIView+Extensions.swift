import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // Start from the top
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // End at the bottom
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


