//
//  NowPlayingViewController.swift
//  Week1Assignment
//
//  Created by Thomas Bender on 9/6/18.
//  Copyright © 2018 Thomas Bender. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingActIndicator: UIActivityIndicatorView!
  
  //var movies: [[String: Any]] = []
  var movies: [Movie] = []
  //var filteredMovies: [[String: Any]] = [] //for search function
  var filteredMovies: [Movie] = []
  var searchActive: Bool = false     //maintains state of whether searchBar is usable. If
  
  var refreshControl: UIRefreshControl!
  
  
  override func viewDidLoad() {
    //test
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    tableView.dataSource = self
    
    fetchMovies()
    filteredMovies = movies
    searchBar.delegate = self
    searchBar.text = ""
    self.tableView.reloadData()
    print(movies.count)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // When there is no text, filteredData is the same as the original data
    // When user has entered text into the search box
    // Use the filter method to iterate over all items in the data array
    // For each item, return true if the item should be included and false if the
    // item should NOT be included


    print("search bar code will happen")

    if searchText.isEmpty {
      print("empty search")
    }
    filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: Movie) -> Bool in

      // If dataItem matches the searchText, return true to include it
      let title = item.title 
      let range =  title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
      return range
    }
    tableView.reloadData()
  }

  //TODO: Fix search bar
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true
  }
  
  @objc func didPullToRefresh (_ refreshControl: UIRefreshControl) {
    fetchMovies()
  }
  
  func displayError () {
    let networkAlertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connect appears to be offline.", preferredStyle: .alert)
    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
      self.fetchMovies()
    }
    networkAlertController.addAction(tryAgainAction)
    
    present(networkAlertController, animated: true) {
    }
  }
  
  
  func fetchMovies() {
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data, response, error) in
      self.loadingActIndicator.startAnimating()
      
      if let error = error {
        print(error.localizedDescription)
        self.displayError()
      } else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
        self.movies = [] //empties array before filling it again
        for i in movieDictionaries {
          self.movies.append(Movie(dictionary: i))    //iterates and adds movies
        }
        self.tableView.reloadData()
        
        self.noticeSuccess("Updated", autoClear: true)
        self.refreshControl.endRefreshing()
        
      }
      self.loadingActIndicator.stopAnimating()
    }
    task.resume()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if searchActive {
      return filteredMovies.count
    }
    return movies.count

  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    var movie = movies[indexPath.row]
    if searchActive {
      movie = filteredMovies[indexPath.row]       //switch over to filteredmovies array when the search starts
    }
    //print(movie)
//    let title = movie["title"] as! String
    let title = movie.title
//    let overview = movie["overview"] as! String
    let overview = movie.overview
//    let posterPathString = movie["poster_path"] as! String
//    let baseURLString = "https://image.tmdb.org/t/p/w500"
//    let posterURL = URL(string: baseURLString + posterPathString)!
    let posterURL = movie.posterURL
    
    let posterPlaceholderImage = UIImage (named: "now_playing_tabbar_item")
    
      cell.posterImageViewer.af_setImage(withURL: posterURL!, placeholderImage: posterPlaceholderImage)
    
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    
    return cell
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let cell = sender as! UITableViewCell
    if let indexPath = tableView.indexPath(for: cell) {
      var movie = movies[indexPath.row]
      if searchActive {
        movie = filteredMovies[indexPath.row]
      }
      let detailViewController = segue.destination as! DetailViewController
      detailViewController.movie = movie
    }
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
