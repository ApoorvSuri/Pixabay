//
//  SearchPhotosDomain.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//

import Foundation

struct SearchPhotosDomain: Decodable {
    var hits: [PhotoDomain]
    enum CodingKeys: CodingKey {
        case hits
    }
}
