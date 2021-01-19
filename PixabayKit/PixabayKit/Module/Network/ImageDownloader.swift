//
//  ImageDownloader.swift
//  FlickrPhotos
//
//  Created by cronycle on 18/05/2019.
//  Copyright © 2019 ApoorvSuri. All rights reserved.
//

import UIKit

public enum PhotoState {
    case new, downloaded, failed, downloading
}

public protocol ImageDownloadable {
    var state: PhotoState { get set }
    var id: Int { get set }
    var url: String { get set }
}

public class ImageDownloader: NSObject {
    
    public static let shared = ImageDownloader()
    private let imageCache: NSCache<NSString, UIImage>
    private var session: URLSession!
    private var operations: [OperationsModel] = []
    private var downloadQueue = OperationQueue()
    
    private override init() {
        self.session = URLSession.shared
        self.imageCache = NSCache()
    }
    
    public func download(photo: ImageDownloadable, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        let operation = BlockOperation.init {
            if let cachedImage = self.imageCache.object(forKey: photo.url as NSString) {
                completion(cachedImage, nil)
            } else {
                guard let url = URL.init(string: photo.url) else {
                    completion(nil, nil)
                    return
                }
                let task = self.session.dataTask(with: url, completionHandler: { (data, _, error) in
                    if let error = error {
                        completion(nil, error)
                    } else if let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image, nil)
                    } else {
                        completion(nil, nil)
                    }
                })
                task.resume()
            }
        }
        downloadQueue.addOperation(operation)
        let photoOp = OperationsModel.init(photo: photo, operation: operation)
        operations.append(photoOp)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                if let index = self.operations.firstIndex(where: {$0.photo.id == photo.id}) {
                    self.operations.remove(at: index)
                }
            }
        }
    }
    
    public func raiseDownloadPriority(forPhoto photo: ImageDownloadable) {
        if let downloadOpIndex = operations.firstIndex(where: {$0.photo.id == photo.id}) {
            operations[downloadOpIndex].operation.queuePriority = .veryHigh
        }
    }
    
    public func reduceDownloadPriority(forPhoto photo: ImageDownloadable) {
        if let downloadOpIndex = operations.firstIndex(where: {$0.photo.id == photo.id}) {
            operations[downloadOpIndex].operation.queuePriority = .normal
        }
    }
    
    public func cancalAllDownloads() {
        downloadQueue.cancelAllOperations()
    }
    public func pauseAllDownloads() {
        downloadQueue.isSuspended = true
    }
    public func resumeAllDownloads() {
        downloadQueue.isSuspended = false
    }
}
