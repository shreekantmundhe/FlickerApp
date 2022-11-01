//
//  PhotoSearchAPI.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation

protocol PhotoSearchAPIServiceProtocol {
    func getImageList(_ tags: String, completion: @escaping (_ success: Bool, _ results: [FlickrURLs]?, _ error: PhotoSearchAPIResultError?) -> ())
}

enum PhotoSearchAPIResultError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class PhotoSearchAPI: PhotoSearchAPIServiceProtocol {
    
  typealias PhotoSearchAPIDataCompletion = (Bool, [FlickrURLs]?, PhotoSearchAPIResultError?) -> ()
  
  private let apiKey = "2258a13716a5125b8dae87a7d8f332a7"
  private let host = "api.flickr.com"
  private let path = "/services/rest/"
  private let SearchMethod = "flickr.photos.search"
  private let ResponseFormat = "json"
  private let DisableJSONCallback = "1"
  private let MediumURL = "url_m"
  private let SafeSearch = "1"
  
    func getImageList(_ tags: String, completion: @escaping PhotoSearchAPIDataCompletion) {
    var urlBuilder = URLComponents()
    urlBuilder.scheme = "https"
    urlBuilder.host = host
    urlBuilder.path = path
    urlBuilder.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "method", value: SearchMethod),
      URLQueryItem(name: "format", value: ResponseFormat),
      URLQueryItem(name: "nojsoncallback", value: DisableJSONCallback),
      URLQueryItem(name: "extras", value: MediumURL),
      URLQueryItem(name: "safe_search", value: SafeSearch),
      URLQueryItem(name: "per_page", value: "30"),
      URLQueryItem(name: "tags", value: tags),
      URLQueryItem(name: "tag_mode", value: "any")
    ]
    
    let url = urlBuilder.url!
        //MARK: Use below code if API not working correctly
        guard let path = Bundle.main.path(forResource: "photo", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try JSONDecoder().decode(PhotoSearchResponse.self, from: data)
            if let response = result.photos?.photo {
                completion(true, response, nil)
            }
            
        } catch {
            print(error)
            completion(false, nil, .invalidData)
        }
    
//MARK: Use below code for actual API workable scenario
//    URLSession.shared.dataTask(with: url) { (data, response, error) in
//      //execute completion handler on main thread
//      DispatchQueue.main.async {
//        guard error == nil else {
//          print("Failed request from Flickr: \(error!.localizedDescription)")
//            completion(false, nil, .failedRequest)
//          return
//        }
//
//        guard let data = data else {
//          print("No data returned from Flickr")
//          completion(false, nil, .noData)
//          return
//        }
//
//        guard let response = response as? HTTPURLResponse else {
//          print("Unable to process Flickr response")
//          completion(false, nil, .invalidResponse)
//          return
//        }
//
//        guard response.statusCode == 200 else {
//          print("Failure response from Flickr: \(response.statusCode)")
//          completion(false, nil, .failedRequest)
//          return
//        }
//
//        do {
//          let decoder = JSONDecoder()
//          let searchData = try decoder.decode(PhotoSearchResponse.self, from: data)
//          if let response = result.photos?.photo {
//              completion(true, response, nil)
//          }
//        } catch {
//          print("Unable to decode Flickr response: \(error)")
//          completion(false, nil, .invalidData)
//      }
//      }
//    }.resume()
  }
}

