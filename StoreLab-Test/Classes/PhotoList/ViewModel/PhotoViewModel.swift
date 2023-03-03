//
//  PhotoViewModel.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation
import Combine

class PhotoViewModel {
    
    private var serviceManager: ServiceManager
    @Published var message: String = ""
    @Published var photoList = [Photo]()
    var pageIndex = 1
    var dataLimit = 30
    var apiState: APIState = .initial
    
    init(manager: ServiceManager = ServiceManager()) {
        self.serviceManager = manager
    }
    
    func getPhotosList() {
        
        let param = [Param.page: pageIndex, Param.limit: dataLimit]
        apiState = .inProgress
        serviceManager.getWebService(url: API.photosList.url, params: param) { result in
            switch result {
            case .success(let data):
                self.apiState = .completed
                if let list = try? JSONDecoder().decode([Photo].self, from: data) {
                    if self.apiState == .initial {
                        self.photoList = list
                    } else {
                        self.photoList.append(contentsOf: list)
                    }
                }
            case .failure(let error):
                self.message = error.localizedDescription
            }
        }
    }
    
    func cellForRowValue(indexPath: IndexPath) -> Photo? {
        return photoList.count == 0 ? nil : photoList[indexPath.row]
    }
}
