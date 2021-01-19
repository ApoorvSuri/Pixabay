//
//  SlideshowPhotosRouter.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SlideshowPhotosRoutingLogic {
    
}

protocol SlideshowPhotosDataPassing {
  var dataStore: SlideshowPhotosDataStore? { get }
}

class SlideshowPhotosRouter: NSObject, SlideshowPhotosRoutingLogic, SlideshowPhotosDataPassing {
    
  weak var viewController: SlideshowPhotosViewController?
  var dataStore: SlideshowPhotosDataStore?

}
