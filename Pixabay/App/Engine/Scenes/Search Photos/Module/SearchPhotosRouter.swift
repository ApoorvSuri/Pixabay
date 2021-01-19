//
//  SearchPhotosRouter.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SearchPhotosRoutingLogic {
    
}

protocol SearchPhotosDataPassing {
  var dataStore: SearchPhotosDataStore? { get }
}

class SearchPhotosRouter: NSObject, SearchPhotosRoutingLogic, SearchPhotosDataPassing {
    
  weak var viewController: SearchPhotosViewController?
  var dataStore: SearchPhotosDataStore?

}
