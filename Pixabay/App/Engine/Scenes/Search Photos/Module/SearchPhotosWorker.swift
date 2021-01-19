//
//  SearchPhotosWorker.swift
//  Pixabay
//
//  Created by synup on 19/01/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import PixabayKit

typealias SearchPhotoCompletion = (SearchPhotosDomain?, Error?) -> Void

enum SearchPhotosWorkerError: Error {
    case invalidURL
    case invalidFormat
}

protocol SearchPhotosWorkerDataSource {
    func getPhotosByName(_ name: String, completion: @escaping SearchPhotoCompletion)
}

class SearchPhotosWorker {
    
    var remoteDataSource: SearchPhotosWorkerDataSource
    var localDataSource: SearchPhotosWorkerDataSource?
    
    init(withDataSource remoteDataSource: SearchPhotosWorkerDataSource, localDataSource: SearchPhotosWorkerDataSource? = nil) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getPhotosByName(_ name: String, completion: @escaping SearchPhotoCompletion) {
        remoteDataSource.getPhotosByName(name, completion: completion)
        //add to database after fetching here
    }
}

class SearchPhotosRemoteDatasource: SearchPhotosWorkerDataSource {
    
    struct SearchPhotosRequest: APIRequest {
        
        typealias RequestDataType = String
        typealias ResponseDataType = SearchPhotosDomain
        
        var currentPage = 1

        init(withCurrentPage currentPage: Int) {
            self.currentPage = currentPage
        }

        func makeRequest(from data: String) throws -> URLRequest {
            guard let url = URL.searchImages(withName: data, page: currentPage) else { throw SearchPhotosWorkerError.invalidURL }
            return URLRequest.init(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        }
        
        func parseResponse(data: Data) throws -> SearchPhotosDomain {
            let decoder = JSONDecoder.init()
            do {
                 let data = try! decoder.decode(SearchPhotosDomain.self, from: data)
                return data
            } catch let error {
                throw error
            }
        }
    }
    
    var currentPage = 1
    var requestLoader: APIRequestLoader<SearchPhotosRequest>?
    
    func getPhotosByName(_ name: String, completion: @escaping SearchPhotoCompletion) {
        requestLoader = APIRequestLoader.init(apiRequest: SearchPhotosRequest(withCurrentPage: currentPage))
        requestLoader!.loadAPIRequest(requestData: name, completionHandler: completion)
        currentPage += 1
    }
}

class SearchPhotosLocalDatasource: SearchPhotosWorkerDataSource {
    func getPhotosByName(_ name: String, completion: @escaping SearchPhotoCompletion) {
        //Core data code here
    }
}
