import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the gradient background
        view.setGradientBackground(colorOne: UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 0), // Pastel blue
                                   colorTwo: UIColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 1)) // Pastel purple

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Remove the old gradient layer
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        // Add a new gradient layer with the correct frame
        view.setGradientBackground(colorOne: UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1), // Pastel blue
                                   colorTwo: UIColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 1)) // Pastel purple

    }
}

