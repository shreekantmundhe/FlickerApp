//
//  PhotoDetailsResponseViewModel.swift
//  FlickerApp
//
//  Created by Shrikant Mundhe on 21/09/2022.
//

import Foundation

protocol PhotoInfoModelDelegate {
    func didReceivePhotoInfoResponse(infoResponse: PhotoInfo?)
}
class PhotoDetailsResponseViewModel: NSObject {

    private var photoInfoServiceProtocol: PhotoInfoServiceProtocol
    
    var photoInfoResult: PhotoInfo?
    
    //MARK: Communicating through protocol delegate to perform MVVM
    var delegate : PhotoInfoModelDelegate?

    init(photoInfoServiceProtocol: PhotoInfoServiceProtocol = PhotoDetailsAPI()) {
        self.photoInfoServiceProtocol = photoInfoServiceProtocol
    }
    
    func getPhotoInfo(_ photoID: String) {
        photoInfoServiceProtocol.getPhotoInfoCompletion(photoID: photoID) { success, model, error in
            if success, let response = model {
                self.delegate?.didReceivePhotoInfoResponse(infoResponse: response.photo)
            } else {
                print(error!)
            }
            
        }
    }
}

   
