import UIKit

class EditCinemaViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var availableMovies: [Movie] = []
    var associatedMovies: [Movie] = []

    var cinemaToEdit: Cinema?

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var moviesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

            // Set the data source and delegate for the table view
            moviesTableView.dataSource = self
            moviesTableView.delegate = self

            if let cinema = cinemaToEdit {
                idTextField.text = cinema.id
                nameTextField.text = cinema.name
                locationTextField.text = cinema.location
                // For the movies list, you'll need additional logic to show which movies are associated with this cinema.
            }

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            availableMovies = appDelegate.fetchMovies() as! [Movie]
            if let cinema = cinemaToEdit, let movies = cinema.movies?.allObjects as? [Movie] {
                associatedMovies = movies
            }
            
            // Refresh the table view data
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

            cell.textLabel?.numberOfLines = 0 // Allow the label to display multiple lines
            cell.textLabel?.text = """
            ID: \(id)
            Title: \(movieTitle)
            Directors: \(directors)
            Casts: \(casts)
            Release Date: \(dateString)
            """

            if associatedMovies.contains(movie) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = availableMovies[indexPath.row]

        if let index = associatedMovies.firstIndex(of: selectedMovie) {
            // If movie is already associated, remove it
            associatedMovies.remove(at: index)
        } else {
            // Otherwise, associate the movie
            associatedMovies.append(selectedMovie)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let cinema = cinemaToEdit else { return } // Safely unwrap cinemaToEdit

            // Remove all current movie associations
            for movie in cinema.movies?.allObjects as! [Movie] {
                cinema.removeFromMovies(movie)
            }

            // Add the updated movie associations
            for movie in associatedMovies {
                cinema.addToMovies(movie)
            }

            // Save context after making changes
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()

            // Alert to inform the user about the successful edit
            let alert = UIAlertController(title: "Edited Successfully", message: "Cinema record is edited. Tap Back to see edited record.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // You can add any code here that should be executed after the user taps "OK".
                // For instance, you might want to pop the current view controller to go back to the list of cinemas.
                // self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
    }
}
