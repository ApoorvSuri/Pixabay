//
//  OperationsModel.swift
//  FlickrPhotos
//
//  Created by cronycle on 18/05/2019.
//  Copyright © 2019 ApoorvSuri. All rights reserved.
//

import UIKit

class OperationsModel: NSObject {
    var photo: ImageDownloadable
    var operation: Operation
    init(photo: ImageDownloadable, operation: Operation) {
        self.photo = photo
        self.operation = operation
    }
}
