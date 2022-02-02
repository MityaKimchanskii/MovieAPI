//
//  MovieController.swift
//  MovieAPI
//
//  Created by Mitya Kim on 2/2/22.
//

import UIKit

class MovieController {
    
    // MARK: - URL for Movie
    // https://api.themoviedb.org/3/search/movie?query=movie&api_key=5a502646b18dc2931e38c1dc4f807892
    static let baseURL = URL(string: "https://api.themoviedb.org")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    
    static let queryKey = "query"
    static let apiKey = "api_key"
    static let apiKeyValue = "5a502646b18dc2931e38c1dc4f807892"
    
    // MARK: - URL for Image
    // https://image.tmdb.org/t/p/original/wwemzKWzjKYJFfCeiB57q3r4Bcm.png
    static let baseURLForImage = URL(string: "https://image.tmdb.org/t/p/original")
    
    static func fetchMovie(searchMovie: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let movieQuery = URLQueryItem(name: queryKey, value: searchMovie)
        let apiQuery = URLQueryItem(name: apiKey, value: apiKeyValue)
        components?.queryItems = [movieQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let resultArrayOfMovie = topLevelObject.results
                
                var movieArray: [Movie] = []
                
                for movie in resultArrayOfMovie {
                    movieArray.append(movie)
                }
                
                return completion(.success(movieArray))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImageFor(movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let baseURLForImage = baseURLForImage else { return completion(.failure(.invalidURL)) }
        let imageURL = baseURLForImage.appendingPathComponent(movie.poster_path)
        
        print(imageURL)
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Thumbnail status code: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(image))
            
        }.resume()
    }
}

