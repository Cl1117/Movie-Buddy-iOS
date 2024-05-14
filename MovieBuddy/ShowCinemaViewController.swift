import UIKit

class ShowCinemaViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    var cinemas: [Cinema] = []

    @IBOutlet var cinemasTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cinemasTableView.dataSource = self
        cinemasTableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

            // Fetch cinemas again
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            cinemas = appDelegate.fetchCinemas() // Assuming fetchCinemas() returns [Cinema]
            cinemasTableView.reloadData() // Use your table view's outlet name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCinemaSegue" {
            if let destinationVC = segue.destination as? EditCinemaViewController,
               let indexPath = cinemasTableView.indexPathForSelectedRow, // Corrected this
               let cinema = cinemas[indexPath.row] as? Cinema { // Corrected this
                destinationVC.cinemaToEdit = cinema
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath)
            let cinema = cinemas[indexPath.row]

            // Extracting the properties
            let id = cinema.id ?? ""
            let name = cinema.name ?? ""
            let location = cinema.location ?? ""

            // Extract movie titles from the movies associated with the cinema
            let movieTitles = (cinema.movies?.allObjects as? [Movie])?.map { $0.movieTitle ?? "" } ?? []
            let moviesString = movieTitles.joined(separator: ", ")
        
            print("Movies for cinema \(id): \(moviesString)")


            // Formatting the content
            cell.textLabel?.numberOfLines = 0 // This allows the label to display multiple lines
            cell.textLabel?.text = """
            ID: \(id)
            Name: \(name)
            Location: \(location)
            Movies: \(moviesString)
            """

            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCinema = cinemas[indexPath.row]
        // Here, you can perform a segue to the Edit Cinema Controller and pass the selectedCinema
        // You'll set this up after creating the Edit Cinema Controller.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the cinema to delete
            let cinemaToDelete = cinemas[indexPath.row]
            
            // Delete from the context
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(cinemaToDelete)
            
            // Try to save the context
            do {
                try context.save()
            } catch {
                print("Error deleting cinema: \(error)")
            }
            
            // Remove from the data source array
            cinemas.remove(at: indexPath.row)
            
            // Remove from the table view with animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
