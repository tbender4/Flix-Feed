//
//  Movie.swift
//  Flix-Finder
//
//  Created by Thomas Bender on 10/9/18.
//  Copyright © 2018 Thomas Bender. All rights reserved.
//

enum MovieKeys {
  static let title = "title"
  static let releaseDate = "release_date"
  static let overview = "overview"
  static let backdropPath = "backdrop_path"
  static let posterPath = "poster_path"
}

import Foundation

//Defines properties of a movie

class Movie {
  var title: String
  var overview: String
  var posterPathString: String
  var posterURL: URL?
  
  //additional for detail view
  var releaseDate: String
  var backdropPathString: String
  var backdropURL: URL?
  
  
  let baseURL = "https://image.tmdb.org/t/p/w500"
  
  init() {                                        //should all get overwritten by segue
    title = "defaultTitle"
    overview = "defaultOverview"
    posterPathString = "defaultpps"
    releaseDate = "defaultReleaseDate"
    backdropPathString = "defaultPosterPathString"
  }
  
  init(dictionary: [String: Any]) {
    title = dictionary[MovieKeys.title] as? String ?? "No title"
    overview = dictionary[MovieKeys.overview] as? String ?? "No overview"
    posterPathString = dictionary[MovieKeys.posterPath] as? String ?? "No poster"
    releaseDate = dictionary[MovieKeys.releaseDate] as? String ?? "No release date"
    backdropPathString = dictionary[MovieKeys.backdropPath] as? String ?? "No backdrop"
    
    if posterPathString == "No poster" {
      posterURL = nil
    } else {
      posterURL = URL(string: baseURL + posterPathString)
    }
    if backdropPathString == "No backdrop" {
      backdropURL = nil
    } else {
      backdropURL = URL(string: baseURL + backdropPathString)
    }
  }
  
  class func movies(dictionaries: [[String: Any]]) -> [Movie] {
    var movies: [Movie] = []
    for dictionary in dictionaries {
      let movie = Movie(dictionary: dictionary)
      movies.append(movie)
    }
    return movies
  }
  
}
