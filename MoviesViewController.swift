@@ -2,7 +2,7 @@

import UIKit
import AFNetworking
class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var networkErrorView: UIView!
    
@@ -10,8 +10,11 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var allMovies: [NSDictionary]?
    var ifLoaded = false
    var endpoint: String!
    override func viewDidAppear(animated: Bool) {
@@ -25,12 +28,18 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        self.navigationItem.title = "Flicks"
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        networkErrorView.hidden = true
        //networkErrorView.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        //searchBar.text = "test"
        filteredMovies = movies
        print("view loaded")
        
        
@@ -51,14 +60,14 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
                            //NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                            self.allMovies = self.movies
                    }
                }
                else
                {
                    //self.networkErrorView.hidden = false
                    
                    EZLoadingActivity.hide(success: false, animated: false)
                    self.networkErrorView.hidden = false
                    //self.networkErrorView.hidden = false
                }
        });
        task.resume()
@@ -90,16 +99,34 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String
        {
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.posterView.setImageWithURL(imageUrl!)
            let imageUrl = NSURLRequest(URL: NSURL(string: baseUrl + posterPath)!)
            //let imageUrl = "https://i.imgur.com/tGbaZCY.jpg"
            //let imageRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
            
            cell.posterView.alpha = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                cell.posterView.alpha = 1.0
            cell.posterView.setImageWithURLRequest(
                imageUrl,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        EZLoadingActivity.hide(success: true, animated: false)
@@ -125,7 +152,7 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
    func refreshControlAction(refreshControl: UIRefreshControl) {
        EZLoadingActivity.show("Loading...", disableUI: true)
        // Make network request to fetch latest data
        networkErrorView.hidden = true
        //networkErrorView.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
@@ -157,7 +184,7 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
                {
                    //self.networkErrorView.hidden = false
                    EZLoadingActivity.hide(success: false, animated: false)
                    self.networkErrorView.hidden = false
                    //self.networkErrorView.hidden = false
                }
        });
        task.resume()
@@ -190,5 +217,23 @@ class MoviesViewController: UIViewController,UITableViewDataSource,UITableViewDe
    // Pass the selected object to the new view controller.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        movies = allMovies
        filteredMovies = searchText.isEmpty ? movies : movies!.filter {
            $0["title"]!.containsString(searchText)
        }
        movies = filteredMovies
        tableView.reloadData()
        print("searchbar updated")
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        print("searchbar canceled")
        movies = allMovies
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    
} 
