import CoreData
import UIKit

class AddCinemaViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var availableMovies: [Movie] = []
    var selectedMovies: [Movie] = []

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var moviesTableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source and delegate for the table view
        moviesTableView.dataSource = self
        moviesTableView.delegate = self

        // Fetch movies
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        availableMovies = appDelegate.fetchMovies() as! [Movie]

        moviesTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
            let movie = availableMovies[indexPath.row]

            let id = movie.id ?? ""
            let movieTitle = movie.movieTitle ?? ""
            let directors = movie.directors ?? ""
            let casts = movie.casts ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let inputDate = movie.inputDate ?? Date()
            let dateString = dateFormatter.string(from: inputDate)

            cell.textLabel?.numberOfLines = 0 // This allows the label to display multiple lines
            cell.textLabel?.text = """
            ID: \(id)
            Title: \(movieTitle)
            Directors: \(directors)
            Casts: \(casts)
            Release Date: \(dateString)
            """

            cell.accessoryType = selectedMovies.contains(movie) ? .checkmark : .none
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = availableMovies[indexPath.row]
        if let index = selectedMovies.firstIndex(of: selectedMovie) {
            selectedMovies.remove(at: index)
        } else {
            selectedMovies.append(selectedMovie)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let newCinema = Cinema(context: context)
        newCinema.id = idTextField.text
        newCinema.name = nameTextField.text
        newCinema.location = locationTextField.text

        for movie in selectedMovies {
            newCinema.addToMovies(movie)
        }

        do {
            try context.save()
            // Optionally, you can add an alert here to inform the user that the cinema has been saved successfully
            let alert = UIAlertController(title: "Success", message: "Cinema has been added. Tap Back to manage cinema record.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } catch {
            print("Error saving cinema: \(error)")
            // Optionally, you can add an alert here to inform the user about the error
            let alert = UIAlertController(title: "Error", message: "There was an error saving the cinema.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
