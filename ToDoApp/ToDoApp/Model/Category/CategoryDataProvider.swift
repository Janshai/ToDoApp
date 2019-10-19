//
//  CategoryDataProvider.swift
//  ToDoApp
//
//  Created by Jack Adams on 30/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import Alamofire

class NetworkCategoryDataProvider: CategoryDataProvider {
    
    private var baseURL: String
    
    init(baseURL: String? = nil) {
        self.baseURL = (baseURL ?? Config.apiBaseURL) + "category/"
    }
    
    func fetchCategories(onCompletion completion: @escaping (Result<[Category], Error>) -> Void) {
        AF.request(baseURL).validate().responseDecodable() { (response: DataResponse<CategoryResponse>) in
            switch self.handleErrors(forCategoryDataResponse: response) {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func addCategory(withValues values: [CategoryFields : Encodable], andOnCompletion completion: @escaping (Result<Category, Error>) -> Void) {
        let params = CategoryParameters(withDict: values)
        AF.request(baseURL, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate().responseDecodable() { (response: DataResponse<CategoryResponse>) in
            
            switch self.handleErrors(forCategoryDataResponse: response) {
            case .success(let category): completion(.success(category[0]))
            case .failure(let error): completion(.failure(error))
            }
            
        }
    }
    
    func updateCategory(withID id: String, withNewValues newValues: [CategoryFields : Encodable], andOnCompletion completion: @escaping (Result<Category, Error>) -> Void) {
        let url = baseURL + id
        let params = CategoryParameters(withDict: newValues)
        
        AF.request(url, method: .put, parameters: params, encoder: JSONParameterEncoder.default).validate().responseDecodable() { (response: DataResponse<CategoryResponse>) in
            
            switch self.handleErrors(forCategoryDataResponse: response) {
            case .success(let category): completion(.success(category[0]))
            case .failure(let error): completion(.failure(error))
            }
        }
        
    }
    
    func deleteCategory(withID id: String) {
        
        let url = baseURL + id
        AF.request(url, method: .delete).responseDecodable() { (response: DataResponse<CategoryResponse>) in
            switch response.value?.success {
            case true:
                print("successfully deleted")
            case false:
                if let error = response.value?.error {
                    print(error)
                }
            default:
                break
                
            }
        }
    }
    
    private func handleErrors(forCategoryDataResponse response: DataResponse<CategoryResponse>) -> Result<[Category], Error> {
        switch response.result {
        case .failure(let error): return .failure(error)
        case .success(let categoryResponse):
            if categoryResponse.success {
                
                if let category = categoryResponse.category {
                    return .success([category])
                } else if let categories = categoryResponse.categories {
                    return .success(categories)
                } else {
                    return .failure(NSError(domain: "Invalid Response", code: 0000))
                }
            } else {
                
                if let error = categoryResponse.error {
                    return .failure(NSError(domain: error, code: 0000))
                } else {
                    return .failure(NSError(domain: "Invalid Response", code: 0000))
                }
            }
        }
    }
    
}

protocol CategoryDataProvider {
    func fetchCategories(onCompletion: @escaping (_ result: Result<[Category], Error>) -> Void)
    
    func addCategory(withValues: [CategoryFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Category, Error>) -> Void)
    
    func updateCategory(withID: String, withNewValues: [CategoryFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Category, Error>) -> Void)
    
    func deleteCategory(withID: String)
}

fileprivate class CategoryParameters: Encodable {
    
    var name: String?
    var colour: String?
    var emoji: String?
    
    init?(withDict dict: [CategoryFields:Encodable]) {
        if let name = dict[.name] as? String {
            self.name = name
        }
        if let colour = dict[.colour] as? String {
            self.colour = colour
        }
        if let emoji = dict[.emoji] as? String {
            self.emoji = emoji
        }
    }
}

enum CategoryFields: String, Hashable {
    case name
    case colour
    case emoji
}
