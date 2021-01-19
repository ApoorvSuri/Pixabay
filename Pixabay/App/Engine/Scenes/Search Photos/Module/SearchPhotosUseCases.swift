//
//  SearchPhotosModels.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import PixabayKit

enum SearchPhotosUseCases {
  // MARK:- Use cases
  
    struct SearchPhoto {
        
        struct Request {
            var name: String
        }
        
        struct Response {
            var photos: [PhotoInterface]
        }
        
        class ViewModel {
            
            static let thumbnail = UIImage.init(named: "ic_placeholder")!
            
            var photos: [PhotoDomain] = []
            var numberOfSection: Int = 2
            var reloadBlock: ((_ index: IndexPath) -> Void)?
            
            func append(_ photos: [PhotoDomain]) {
                self.photos.append(contentsOf: photos)
            }
            
            func viewWillApper() {
                ImageDownloader.shared.resumeAllDownloads()
            }
            
            func viewWillDisappear() {
                ImageDownloader.shared.pauseAllDownloads()
            }
            
            func viewDidEndDisplayingResults() {
                ImageDownloader.shared.cancalAllDownloads()
            }
            
            func items(inSection section: Int) -> Int {
                photos.count
            }
            
            func viewModel(forIndex index: IndexPath) -> PhotoCollectionCellViewModel {
                let photo = photos[index.item]
                if photo.state == .new {
                    download(photo: photo, completion: {[weak self] _ in
                        self?.reloadBlock?(index)
                    })
                }
                return PhotoCollectionCellViewModel(image: photo.downloadedImage ?? SearchPhotosUseCases.SearchPhoto.ViewModel.thumbnail)
            }
            
            func willDisplay(_ indexPath: IndexPath) {
                ImageDownloader.shared.raiseDownloadPriority(forPhoto: self.photos[indexPath.item])
            }
            
            func didEndDisplaying(_ indexPath: IndexPath) {
                ImageDownloader.shared.reduceDownloadPriority(forPhoto: self.photos[indexPath.item])
            }
            
            func download(photo: PhotoDomain, completion: ((Result<UIImage,Error>) -> Void)?) {
                ImageDownloader.shared.download(photo: photo) {(image, error) in
                    OperationQueue.main.addOperation({
                        if error != nil {return}
                        photo.state = image == nil ? .failed : .downloaded
                        photo.downloadedImage = image
                        let downloadedImage = image ?? SearchPhotosUseCases.SearchPhoto.ViewModel.thumbnail
                        completion?(.success(downloadedImage))
                    })
                }
            }
        }
    }
}
