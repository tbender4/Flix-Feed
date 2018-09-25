//
//  SuperheroViewController.swift
//  Week1Assignment
//
//  Created by Thomas Bender on 9/20/18.
//  Copyright © 2018 Thomas Bender. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var movies: [[String: Any]] = []
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies.count
  }
  
  func fetchMovies() {
    let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data, response, error) in
      //     self.loadingActIndicator.startAnimating()
      
      if let error = error {
        print(error.localizedDescription)
        //self.displayError()
      } else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        //print(dataDictionary)
        let movies = dataDictionary["results"] as! [[String: Any]]
        self.movies = movies
        self.collectionView.reloadData()
        self.noticeSuccess("Updated", autoClear: true)
        //self.refreshControl.endRefreshing()
        
      }
      //       self.loadingActIndicator.stopAnimating()
    }
    task.resume()
    
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
    let movie = movies[indexPath.item]
    if let posterPathString = movie["poster_path"] as? String {
      let baseURLString = "https://image.tmdb.org/t/p/w500"
      let posterURL = URL(string: baseURLString + posterPathString)!
      cell.posterImageView.af_setImage(withURL: posterURL)
    }
    return cell
    
  }
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
    layout.minimumInteritemSpacing = 5
    layout.minimumLineSpacing = layout.minimumInteritemSpacing

    
    let cellsPerLine: CGFloat = 2
    let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
    let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
    
    layout.itemSize = CGSize(width: width, height: width * 3 / 2)
    
    fetchMovies()
    
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
