//
//  SlideshowPhotosViewController.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol SlideshowPhotosDisplayLogic: class {
    
}

class SlideshowPhotosViewController: UIViewController, SlideshowPhotosDisplayLogic {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var interactor: SlideshowPhotosBusinessLogic?
    var router: (NSObjectProtocol & SlideshowPhotosRoutingLogic & SlideshowPhotosDataPassing)?
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = SlideshowPhotosInteractor()
        let presenter = SlideshowPhotosPresenter()
        let router = SlideshowPhotosRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
