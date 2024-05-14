import CoreData
import UIKit

class ShowMovieController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: [NSManagedObject] = []

    @IBOutlet var moviesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        moviesTableView.dataSource = self
        moviesTableView.delegate = self

        moviesTableView.estimatedRowHeight = 150
        moviesTableView.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        movies = appDelegate.fetchMovies()
        moviesTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMovieSegue" {
            if let destinationVC = segue.destination as? EditMovieViewController,
               let movie = sender as? NSManagedObject {
                destinationVC.movieToEdit = movie
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]

        let id = movie.value(forKey: "id") as? String ?? ""
        let movieTitle = movie.value(forKey: "movieTitle") as? String ?? ""
        let directors = movie.value(forKey: "directors") as? String ?? ""
        let casts = movie.value(forKey: "casts") as? String ?? ""
        let inputDate = movie.value(forKey: "inputDate") as? Date ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: inputDate)

        cell.textLabel?.numberOfLines = 0 // This allows the label to display multiple lines
        cell.textLabel?.text = """
        ID: \(id)
        Title: \(movieTitle)
        Directors: \(directors)
        Casts: \(casts)
        Date: \(dateString)
        """

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "EditMovieSegue", sender: selectedMovie)
    }
    
    // Delete cell function
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch the movie to delete
            let movieToDelete = movies[indexPath.row]
            
            // Delete the movie from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.context.delete(movieToDelete)
            appDelegate.saveContext()
            
            // Remove the movie from the movies array
            movies.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func clearMovieRecords(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.removeMovieRecords()
    }
}
