//
//  URLService.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//

import Foundation

extension URL {
    static let apiKey = "19942298-5f0b49ebbdc76a343e8934b57"
    static func searchImages(withName name: String, page: Int) -> URL? {
        let url = "https://pixabay.com/api/?key=\(apiKey)&q=\(name)&image_type=photo&page=\(page)&per_page=10"
        return URL.init(string: url)
    }
}
