//
//  PhotoInterface.swift
//  PixabayKit
//
//  Created by synup on 19/01/21.
//

import Foundation

public protocol PhotoInterface: ImageDownloadable {
    var pageURL: String? {get set}
    var type: String? {get set}
    var tags: String? {get set}
    var previewURL: String? {get set}
    var webformatURL: String? {get set}
    var largeImageURL: String? {get set}
    var fullHDURL: String? {get set}
    var imageURL: String? {get set}
}
