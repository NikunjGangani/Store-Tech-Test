//
//  ServiceManagerMock.swift
//  StoreLab-TestTests
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

class ServiceManagerMock: ServiceManager {
    var data: Data?
    
    override func getWebService(url: URL, params: [String: Any], completionHandler: @escaping ((Result<Data, ServiceError>) -> Void)){
        var finalUrl = url
        finalUrl.append(queryItems: params.map({ return URLQueryItem(name: $0.key, value: "\($0.value)")}))
        let dataTask = URLSession.shared.dataTask(with: finalUrl) { data, response, error in
            guard error == nil, let data = data else {
                completionHandler(.failure(.invalidURL))
                return
            }
            completionHandler(.success(data))
        }
        dataTask.resume()
    }
}
