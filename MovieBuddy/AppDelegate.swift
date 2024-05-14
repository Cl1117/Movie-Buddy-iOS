import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieBuddy")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext { // new stuff testing
            return persistentContainer.viewContext
        }

    // MARK: - Core Data Saving support

    func saveContext() {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // all functions for core data are here, helper function to get the context for Core Data
    /*func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }*/

    // Movie db, need heaps of refactor here

    // Store function for Movie data into the database
    func storeMovieInfo(inputDate: Date, casts: String, directors: String, id: String, movieTitle: String) {
        //let context = getContext()

        // Retrieve the entity that we just created
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)

        // Set the entity values
        transc.setValue(inputDate, forKey: "inputDate")
        transc.setValue(casts, forKey: "casts")
        transc.setValue(directors, forKey: "directors")
        transc.setValue(id, forKey: "id")
        transc.setValue(movieTitle, forKey: "movieTitle")

        // Save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }

    // Fetch function to get Movie data from the database
    func fetchMovies() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }


    // Function to remove all records from the Pizza table
    func removeMovieRecords() {
        
        // Delete everything in the table Pizza
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("There was an error")
        }
    }
    
    // Cinema functions
    func fetchCinemas() -> [Cinema] {
        let fetchRequest: NSFetchRequest<Cinema> = Cinema.fetchRequest()
        
        do {
            let cinemas = try context.fetch(fetchRequest)
            return cinemas
        } catch let error as NSError {
            print("Could not fetch cinemas. \(error), \(error.userInfo)")
            return []
        }
    }


}
