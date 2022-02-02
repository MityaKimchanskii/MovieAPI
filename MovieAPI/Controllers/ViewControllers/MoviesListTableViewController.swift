//
//  MoviesListTableViewController.swift
//  MovieAPI
//
//  Created by Mitya Kim on 2/2/22.
//

import UIKit

import UIKit

class MoviesListTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchSB: UISearchBar!
    
    // MARK: - Properties
    var movies: [Movie] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchSB.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        cell.movie = movie
        return cell
    }
}

extension MoviesListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchMovie = searchSB.text else { return }
        
        MovieController.fetchMovie(searchMovie: searchMovie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self.movies = movies
                    self.tableView.reloadData()
                    searchBar.text = ""
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}

