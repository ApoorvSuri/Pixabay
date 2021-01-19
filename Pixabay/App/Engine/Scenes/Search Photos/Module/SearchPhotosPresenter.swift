//
//  SearchPhotosPresenter.swift
//  Pixabay
//
//  Created by Apoorv on 19/01/21.
//  Copyright (c) 2021 Apoorv Suri. All rights reserved.

import UIKit

protocol SearchPhotosPresentationLogic {
    func showPhotos(_ response: SearchPhotosUseCases.SearchPhoto.Response)
}

class SearchPhotosPresenter: SearchPhotosPresentationLogic {
    
    weak var viewController: SearchPhotosDisplayLogic?
    
    func showPhotos(_ response: SearchPhotosUseCases.SearchPhoto.Response) {
        let viewModel = SearchPhotosUseCases.SearchPhoto.ViewModel()
        viewModel.photos = response.photos.compactMap({ PhotoDomain.init(pageURL: $0.pageURL
                                                                         , type: $0.type
                                                                         , tags: $0.type
                                                                         , previewURL: $0.previewURL
                                                                         , webformatURL: $0.webformatURL
                                                                         , largeImageURL: $0.largeImageURL
                                                                         , fullHDURL: $0.fullHDURL
                                                                         , imageURL: $0.imageURL
                                                                         , state: $0.state
                                                                         , id: $0.id
                                                                         , downloadedImage: nil)})
        DispatchQueue.main.async {[weak self] in
            self?.viewController?.showPhotos(viewModel)
        }
    }
}
