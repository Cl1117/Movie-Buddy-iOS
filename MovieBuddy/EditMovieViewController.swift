import CoreData
import UIKit

class EditMovieViewController: BaseViewController {
    var movieToEdit: NSManagedObject?
    var movie: NSManagedObject?

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var movieTitleTextField: UITextField!
    @IBOutlet var directorsTextField: UITextField!
    @IBOutlet var castsTextField: UITextField!
    @IBOutlet var inputDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = movieToEdit {
            idTextField.text = movie.value(forKey: "id") as? String
            movieTitleTextField.text = movie.value(forKey: "movieTitle") as? String
            directorsTextField.text = movie.value(forKey: "directors") as? String
            castsTextField.text = movie.value(forKey: "casts") as? String
            if let date = movie.value(forKey: "inputDate") as? Date {
                inputDatePicker.date = date
            }
        }
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        print("Save button was pressed.")
        print("movieToEdit is: \(String(describing: movieToEdit))")

        if let movie = movieToEdit {
            movie.setValue(idTextField.text, forKey: "id")
            movie.setValue(movieTitleTextField.text, forKey: "movieTitle")
            movie.setValue(directorsTextField.text, forKey: "directors")
            movie.setValue(castsTextField.text, forKey: "casts")
            movie.setValue(inputDatePicker.date, forKey: "inputDate")

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()

            // Alert user that the movie record has been edited
            let alert = UIAlertController(title: "Edited Successfully", message: "Movie record is edited. Tap Back to see edited record.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Pop back to previous view controller after user taps "OK"
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
}
