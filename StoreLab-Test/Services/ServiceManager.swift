//
//  ServiceManager.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

enum APIState {
    case initial
    case inProgress
    case completed
}

enum API : String {
    static let BaseURL = "\(Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? "")"
    case photosList = "list"
    var url : URL {
        get{
            return URL(string: API.BaseURL + self.rawValue)!
        }
    }
}

enum ServiceError: Error {
    case noData
    case invalidURL
    case error(error: Error)
}

protocol ServiceSession {
    func getWebService(url: URL, params: [String: Any], completionHandler: @escaping ((Result<Data, ServiceError>) -> Void))
}

extension URLSession: ServiceSession {

    func getWebService(url: URL, params: [String: Any], completionHandler: @escaping ((Result<Data, ServiceError>) -> Void)){
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

class ServiceManager {
    private let session: ServiceSession
    init(session: ServiceSession = URLSession.shared) {
        self.session = session
    }
    
    func getWebService(url: URL, params: [String: Any], completionHandler: @escaping ((Result<Data, ServiceError>) -> Void)) {
        session.getWebService(url: url, params: params, completionHandler: completionHandler)
    }
    
}

