//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Abhijeet Chakrabarti on 2/6/16.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.//

import UIKit
import EZLoadingActivity  //EZLoadingActivity.show("Loading...", disableUI: true) Not sure where to put this line of code...
import AFNetworking


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
   
    @IBOutlet var errorView: UILabel!
   
    @IBOutlet weak var searchBar: UISearchBar!
       
    var refresher: UIRefreshControl!
    
    var filteredData: [NSDictionary]?

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    var movies: [NSDictionary]?

    var selectedMovie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()*/
        
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(MoviesViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()

        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
       
        
               let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
                let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
        
 EZLoadingActivity.show("Loading...", disableUI: true)
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        
       
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    
                    
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            
                            NSLog("response: \(responseDictionary)")
                            
                            
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            
                            self.filteredData = self.movies
                            
                            EZLoadingActivity.hide(true)

                            self.tableView.reloadData()
                                          
                            
                            
                            
                    }
                }
            
            
        });

        
       
task.resume()
        
    
    }

    
   func refresh() {
    
        
        self.tableView.reloadData()
        
        self.refresher.endRefreshing()
        
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredData {
            return filteredMovies.count
        } else {
            return 0
        }    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let rating = movie["vote_average"] as! Double
        
        if  let posterPath = movie["poster_path"] as? String {
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        
        let imageURL = URL(string: baseURL + posterPath)
        
            cell.posterView.setImageWith(imageURL!)
             cell.posterView.alpha = 0
            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.transitionCurlUp, animations: { () -> Void in
                cell.posterView.alpha = 1
                }, completion: nil)
        
        } else {
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = title
        
        cell.overviewCell.text = overview
        
       
        
        cell.ratingLabel.text = String(rating)
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = filteredData![indexPath.row]
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destination as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        
    }
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            if let title = movie["title"] as? String {
                return title.range(of: searchText, options: .caseInsensitive) != nil
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    

}
