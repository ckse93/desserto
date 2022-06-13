//
//  NetworkManager.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import Foundation
import Combine

fileprivate struct UrlEndpoint {
    static let mealListURL: String = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    static let mealDetailByIdURL: String = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
}

fileprivate enum HttpsMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

final class NetworkManager: ObservableObject {
    static let shared: NetworkManager = NetworkManager()
    private let decoder: JSONDecoder = JSONDecoder()
    
    @Published var dessert: Dessert?
    
    func fetchDessert() async throws {
        let request = try self.makeURLRequest(with: UrlEndpoint.mealListURL,
                                          method: .get)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("data fetched: \(String(String(decoding: data, as: UTF8.self)))")
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                if !(200..<300).contains(httpResponse.statusCode) {
                    print("error in the httpsResponse, statusCode: \(httpResponse.statusCode)")
                    throw NetworkManagerError.bonkedResponse
                }
            }
            
            do {
                self.dessert = try decoder.decode(Dessert.self, from: data)
            } catch(let decodingError) {
                print("error while decoding, error: \(decodingError.localizedDescription)")
                throw decodingError
            }
            
        } catch(let fetchError) {
            print("error while fetching, error: \(fetchError.localizedDescription)")
            throw NetworkManagerError.fetchError
        }
    }
    
    func fetchMealDetailById(id: String) async throws -> MealDetail {
        let request = try self.makeURLRequest(with: UrlEndpoint.mealDetailByIdURL + id,
                                          method: .get)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("data fetched: \(String(String(decoding: data, as: UTF8.self)))")
            
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                if !(200..<300).contains(httpResponse.statusCode) {
                    print("error in the httpsResponse, statusCode: \(httpResponse.statusCode)")
                    throw NetworkManagerError.bonkedResponse
                }
            }
            
            do {
                return try decoder.decode(MealDetail.self, from: data)
                
            } catch(let decodingError) {
                print("error while decoding, error: \(decodingError.localizedDescription)")
                throw decodingError
            }
            
        } catch(let fetchError) {
            print("error while fetching, error: \(fetchError.localizedDescription)")
            throw NetworkManagerError.fetchError
        }
    }
    
    private func makeURLRequest(with str: String, method: HttpsMethod) throws -> URLRequest {
        guard let url = URL(string: str) else {
            throw NetworkManagerError.unableToMakeUrl
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
}

enum NetworkManagerError: Error {
    case unableToMakeUrl
    case fetchError
    case bonkedResponse
}
