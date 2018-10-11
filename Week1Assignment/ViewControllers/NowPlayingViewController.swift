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
  

  var movies: [Movie] = []
  var filteredMovies: [Movie] = []
  var searchActive: Bool = false     //maintains state of whether searchBar is used. Used to switch between movies and filteredMovies
  
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
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true
  }
  
  @objc func didPullToRefresh (_ refreshControl: UIRefreshControl) {
    fetchMovies()
  }
  
  func displayError () {
    self.loadingActIndicator.stopAnimating()
    let networkAlertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connect appears to be offline.", preferredStyle: .alert)
    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
      self.fetchMovies()
    }
    networkAlertController.addAction(tryAgainAction)
    present(networkAlertController, animated: true) {
    }
  }
  
  func displaySuccess() {
    self.noticeSuccess("Updated", autoClear: true)
    self.refreshControl.endRefreshing()
    self.loadingActIndicator.stopAnimating()
  }
  
  func fetchMovies() {
    MovieApiManager().popularMovies { (movies: [Movie]?, error: Error?) in
    //MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
      self.loadingActIndicator.startAnimating()
      if let movies = movies {
        self.movies = movies
        self.displaySuccess()
        self.tableView.reloadData()
      } else {
        self.displayError()
      }
    }
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
      movie = filteredMovies[indexPath.row]       //switch to filteredmovies array when the search starts
    }
    cell.movie = movie
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
