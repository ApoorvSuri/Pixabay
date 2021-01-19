//
//  SearchPhotosInteractor.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SearchPhotosBusinessLogic {
    func fetchPhotos(_ request: SearchPhotosUseCases.SearchPhoto.Request)
}

protocol SearchPhotosDataStore {
    
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic, SearchPhotosDataStore {
    
    var presenter: SearchPhotosPresentationLogic?
    var worker: SearchPhotosWorker? = SearchPhotosWorker(withDataSource: SearchPhotosRemoteDatasource())
    
    func fetchPhotos(_ request: SearchPhotosUseCases.SearchPhoto.Request) {
        worker?.getPhotosByName(request.name, completion: { (photos, error) in
            if let photos = photos {
                self.presenter?.showPhotos(SearchPhotosUseCases.SearchPhoto.Response(photos: photos.hits))
            }
        })
    }
}
