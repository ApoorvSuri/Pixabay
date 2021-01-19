//
//  SearchPhotosInteractor.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SearchPhotosBusinessLogic {
    
}

protocol SearchPhotosDataStore {
    
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic, SearchPhotosDataStore {
    
  var presenter: SearchPhotosPresentationLogic?
  var worker: SearchPhotosWorker?
}
