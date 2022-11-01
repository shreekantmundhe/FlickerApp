//
//  GetPhotoInfo.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 20/09/2022.
//

import Foundation

protocol PhotoInfoServiceProtocol {
    func getPhotoInfoCompletion(photoID: String, completion: @escaping (_ success: Bool, _ results: PhotoDetailsResponse?, _ error: PhotoInfoResultError?) -> ())
}

enum PhotoInfoResultError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

class PhotoDetailsAPI: PhotoInfoServiceProtocol {

  typealias PhotoInfoCompletion = (Bool, PhotoDetailsResponse?, PhotoInfoResultError?) -> ()
  
  private let apiKey = "2258a13716a5125b8dae87a7d8f332a7"
  private let host = "api.flickr.com"
  private let path = "/services/rest/"
  private let searchMethod = "flickr.photos.getInfo"
  private let responseFormat = "json"
  private let disableJSONCallback = "1"
  
    func getPhotoInfoCompletion(photoID: String, completion: @escaping PhotoInfoCompletion) {
    var urlBuilder = URLComponents()
    urlBuilder.scheme = "https"
    urlBuilder.host = host
    urlBuilder.path = path
    urlBuilder.queryItems = [
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "method", value: searchMethod),
      URLQueryItem(name: "photo_id", value: photoID),
      URLQueryItem(name: "format", value: responseFormat),
      URLQueryItem(name: "nojsoncallback", value: disableJSONCallback)
    ]
    
    let url = urlBuilder.url!
        
        //MARK: Use below code if API not working correctly
        guard let path = Bundle.main.path(forResource: "details", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try JSONDecoder().decode(PhotoDetailsResponse.self, from: data)
            //if let response = result? as PhotoDetailsResponse {
                completion(true, result, nil)
            //}
            
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
//          print("Failure response from Tag: \(response.statusCode)")
//          completion(false, nil, .failedRequest)
//          return
//        }
//
//        do {
//          let decoder = JSONDecoder()
//          let searchData = try decoder.decode(PhotoDetailsResponse.self, from: data)
//
//          completion(true, searchData, nil)
//        } catch {
//            print("error: ", error)
//        }
//      }
//    }.resume()
  }
}
