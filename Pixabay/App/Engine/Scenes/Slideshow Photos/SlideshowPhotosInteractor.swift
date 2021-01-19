//
//  SlideshowPhotosInteractor.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SlideshowPhotosBusinessLogic {
    
}

protocol SlideshowPhotosDataStore {
    
}

class SlideshowPhotosInteractor: SlideshowPhotosBusinessLogic, SlideshowPhotosDataStore {
    
  var presenter: SlideshowPhotosPresentationLogic?
  var worker: SlideshowPhotosWorker?
}
