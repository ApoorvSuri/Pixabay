//
//  SearchPhotosViewController.swift
//  Pixabay
//
//  Created by Apoorv on 19/01/21.
//  Copyright (c) 2021 Apoorv Suri. All rights reserved.

import UIKit

protocol SearchPhotosDisplayLogic: class {
    func showPhotos(_ viewModel: SearchPhotosUseCases.SearchPhoto.ViewModel?)
    func showError(_ error: Error)
}

class SearchPhotosViewController: UIViewController, SearchPhotosDisplayLogic {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var transitionAnimator = AnimatedTransitioning.init()
    fileprivate var selectedCell: UICollectionViewCell?
    fileprivate var isFetchingMore = false
    
    fileprivate let margin: CGFloat = 10
    fileprivate let maxVerticalItems: CGFloat = 2
    fileprivate let interItemSpace: CGFloat = 5
    fileprivate var searchText = ""
    
    var viewModel: SearchPhotosUseCases.SearchPhoto.ViewModel?
    var interactor: SearchPhotosBusinessLogic?
    var router: (NSObjectProtocol & SearchPhotosRoutingLogic & SearchPhotosDataPassing)?
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = SearchPhotosInteractor()
        let presenter = SearchPhotosPresenter()
        let router = SearchPhotosRouter()
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
        configureSearchUI()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillApper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.viewWillDisappear()
    }
    
    private func setupUI() {
        navigationController?.delegate = self
        collectionView.register(UINib(nibName: "PhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionCell.cellID)
        let nib = UINib(nibName: "LoadMoreCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    fileprivate func getPhotosForSearch(text: String) {
        isFetchingMore = viewModel != nil
        let request = SearchPhotosUseCases.SearchPhoto.Request(name: text)
        interactor?.fetchPhotos(request)
    }
    
    func showPhotos(_ viewModel: SearchPhotosUseCases.SearchPhoto.ViewModel?) {
        if self.viewModel == nil {
            self.viewModel = viewModel
        } else {
            self.viewModel?.append(viewModel?.photos ?? [])
        }
        self.collectionView.reloadData()
        self.viewModel?.reloadBlock = {[weak self] (index) in
            self?.collectionView.reloadItems(at: [index])
        }
    }
    
    func showError(_ error: Error) {
        
    }
}

extension SearchPhotosViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSection ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  section > 0 { return isFetchingMore ? 1 : 0 }
        return viewModel?.items(inSection: section) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isFetchingMore && indexPath.section > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LoadMoreCollectionCell
            cell?.activityIndicator.startAnimating()
            return cell ?? UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.cellID, for: indexPath) as? PhotoCollectionCell
        cell?.setData(viewModel?.viewModel(forIndex: indexPath))
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section > 0 {
            return UIEdgeInsets.zero
        } else {
            return
                UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        }
    }
}

extension SearchPhotosViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        selectedCell = collectionView.cellForItem(at: indexPath)
    ////        if let vc = storyboard?.instantiateViewController(withIdentifier: "imageDetailVC") as? ImageDetailVC {
    ////            vc.photo = photos[indexPath.item]
    ////            navigationController?.pushViewController(vc, animated: true)
    ////        }
    //    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section > 0 { return isFetchingMore ? CGSize.init(width: collectionView.bounds.size.width, height: 40) : CGSize.zero }
        let cellSize: CGFloat = self.view.frame.size.width/maxVerticalItems - (margin + interItemSpace)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.willDisplay(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel?.didEndDisplaying(indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > (contentHeight - scrollView.frame.height) {
            if  isFetchingMore == false && viewModel?.photos.count ?? 0 > 0 && contentHeight > 0 && offsetY >= 30 {
                getPhotosForSearch(text: searchText)
            }
        }
    }
}

// MARK: - Search Display Controller
extension SearchPhotosViewController {
    func configureSearchUI() {
        let searchBar = UISearchBar.init(frame:
                                            CGRect.init(origin: .zero, size: CGSize.init(width: self.view.frame.size.width, height: (navigationController?.navigationBar.frame.height)!)))
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search for image"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}
// MARK: - Delegate : Search Bar delegate
extension SearchPhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == "" {
            return
        }
        self.viewModel?.viewDidEndDisplayingResults()
        self.viewModel = nil
        self.collectionView.reloadData()
        getPhotosForSearch(text: searchBar.text!)
        searchText = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - UINavigationControllerDelegate
extension SearchPhotosViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            guard let cell = selectedCell, let originFrame = cell.superview?.convert(cell.frame, to: nil) else {
                return transitionAnimator
            }
            transitionAnimator.originFrame = originFrame
            return transitionAnimator
        default:
            return nil
        }
    }
}
