import UIKit

class AddMovieController: BaseViewController {
    @IBOutlet var id: UITextField!

    @IBOutlet var movieTitle: UITextField!

    @IBOutlet var directors: UITextField!

    @IBOutlet var casts: UITextField!

    @IBOutlet var inputDate: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveMovieDetail(_ sender: Any) {
        // ensure that all optionals are safely unwrapped before use
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let enteredId = id.text, !enteredId.isEmpty,
              let enteredMovieTitle = movieTitle.text, !enteredMovieTitle.isEmpty,
              let enteredDirectors = directors.text, !enteredDirectors.isEmpty,
              let enteredCasts = casts.text, !enteredCasts.isEmpty else {
            // handle the error, maybe show an alert to the user
            return
        }

        // call function storePizzaInfo in AppDelegate
        appDelegate.storeMovieInfo(inputDate: inputDate.date, casts: enteredCasts, directors: enteredDirectors, id: enteredId, movieTitle: enteredMovieTitle)

        let alert = UIAlertController(title: "Success", message: "Movie has been added. Tap Back to manage movie record.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
