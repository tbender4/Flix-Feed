//
//  NowPlayingViewController.swift
//  Week1Assignment
//
//  Created by Thomas Bender on 9/6/18.
//  Copyright © 2018 Thomas Bender. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingActIndicator: UIActivityIndicatorView!
  
  var movies: [[String: Any]] = []
  var filteredMovies: [[String: Any]] = []            //second array for search function
  var refreshControl: UIRefreshControl!
  
  override func viewDidLoad() {
    //test
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    tableView.dataSource = self
    
    fetchMovies()
    //searchBar.delegate = self
    
  }
  
  /*
  func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredMovies = searchText.isEmpty ? movies : movies.filter {
      let movie = movies[IndexPath.row]
      let title = movie["title"] as! String
      
      (item: title) -> Bool in
      return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    tableView.reloadData()
  }
  */
  
  
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
        //self.noticeError("ERROR", autoClear: true)
        self.displayError()
      } else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        //print(dataDictionary)
        let movies = dataDictionary["results"] as! [[String: Any]]
        self.movies = movies
        self.tableView.reloadData()
        
        self.noticeSuccess("Updated", autoClear: true)
        self.refreshControl.endRefreshing()
        
      }
      self.loadingActIndicator.stopAnimating()
    }
    task.resume()
    
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    
    let movie = movies[indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    let posterPathString = movie["poster_path"] as! String
    let baseURLString = "https://image.tmdb.org/t/p/w500"
    let posterURL = URL(string: baseURLString + posterPathString)!
    
    let posterPlaceholderImage = UIImage (named: "now_playing_tabbar_item")
    cell.posterImageViewer.af_setImage(withURL: posterURL, placeholderImage: posterPlaceholderImage)
    
    //cell.posterImageViewer.set
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    
    return cell
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
