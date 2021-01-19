//
//  PhotoDomain.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//

import PixabayKit

class PhotoDomain: PhotoInterface, Decodable {

    enum CodingKeys: CodingKey {
        case pageURL
        case type
        case tags
        case previewURL
        case webformatURL
        case largeImageURL
        case fullHDURL
        case imageURL
        case id
    }
    
    var pageURL: String?
    
    var type: String?
    
    var tags: String?
    
    var previewURL: String?
    
    var webformatURL: String?
    
    var largeImageURL: String?
    
    var fullHDURL: String?
    
    var imageURL: String?
    
    var state: PhotoState = .new
    
    var id: Int
    
    var url: String {
        get {
            webformatURL ?? ""
        }
        set {
            webformatURL = newValue
        }
    }
    
    var downloadedImage: UIImage?
    
    internal init(pageURL: String? = nil, type: String? = nil, tags: String? = nil, previewURL: String? = nil, webformatURL: String? = nil, largeImageURL: String? = nil, fullHDURL: String? = nil, imageURL: String? = nil, state: PhotoState = .new, id: Int, downloadedImage: UIImage? = nil) {
        self.pageURL = pageURL
        self.type = type
        self.tags = tags
        self.previewURL = previewURL
        self.webformatURL = webformatURL
        self.largeImageURL = largeImageURL
        self.fullHDURL = fullHDURL
        self.imageURL = imageURL
        self.state = state
        self.id = id
        self.downloadedImage = downloadedImage
    }
}
