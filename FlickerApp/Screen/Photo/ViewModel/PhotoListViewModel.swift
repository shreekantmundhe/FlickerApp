//
//  PhotoListViewModel.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 19/09/2022.
//

import Foundation
class PhotoListViewModel: NSObject {

    private var PhotoSearchAPIServiceProtocol: PhotoSearchAPIServiceProtocol
    var reloadTableView: (() -> Void)?

    //MARK: Communicating through clousure to perform MVVM
    var photoCellViewModel = [PhotoCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    init(PhotoSearchAPIServiceProtocol: PhotoSearchAPIServiceProtocol = PhotoSearchAPI()) {
        self.PhotoSearchAPIServiceProtocol = PhotoSearchAPIServiceProtocol
    }

    func searchPhoto(_ searchTearm: String, completion: @escaping (_ success: Bool, _ results: [FlickrURLs]?, _ error: PhotoSearchAPIResultError?) -> ()) {
        PhotoSearchAPIServiceProtocol.getImageList(searchTearm) { [self] success, model, error in
            if success, let response = model {
                self.photoCellViewModel = response.compactMap {createCellModel(photos: $0)}
                completion(success, response, nil)
            } else {
                print(error!)
                completion(success, nil, error)
            }
        }
    }

    func createCellModel(photos: FlickrURLs) -> PhotoCellViewModel {
        let photoID = photos.id ?? ""
        let photo = photos.url_m ?? ""
        let farm = photos.farm ?? 0
        let server = photos.server ?? ""
        let owner = photos.owner ?? ""
        
        return PhotoCellViewModel(photoID: photoID, photo: photo, farm: farm , server: server, owner: owner)
    }

    func getCellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel {
        return photoCellViewModel[indexPath.row]
    }
}
