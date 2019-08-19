//
//  TodoDataProvider.swift
//  ToDoApp
//
//  Created by Jack Adams on 05/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation
import Alamofire

class NetworkTodoDataProvider: TodoDataProvider {
    private var baseURL: String
    init(baseURL: String? = nil) {
       self.baseURL = (baseURL ?? Config.apiBaseURL) + "todo"
    }
    
    func addTodo(withValues values: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Todo, Error>) -> Void) {
        let decoder = createDecoderForMongoDates()
        let params = TodoParameters(withFieldsDict: values)
        
        AF.request(baseURL, method: .post, parameters: params, encoder: JSONParameterEncoder.default).validate().responseDecodable(decoder: decoder) { (response: DataResponse<TodoResponse>) in
            
            switch self.handleErrors(forTodoDataResponse: response) {
            case .success(let todos): completion(.success(todos[0]))
            case .failure(let error): completion(.failure(error))
            }

        }
    }

    func updateTodo(withID id: String, withNewValues values: [TodoFields: Encodable]) {
        let params = TodoParameters(withFieldsDict: values)
        let url = baseURL + "/" + id
        AF.request(url, method: .put, parameters: params, encoder: JSONParameterEncoder.default).responseJSON() { response in
            
            switch response.result {
            case .success(let json): print(json)
            case .failure(let error): print(error)
            }
        }
    }
    
    func deleteTodo(withID id: String) {
        let url = baseURL + "/" + id
        AF.request(url, method: .delete).response() { data in
            print(String(describing:data.response))
        }
    }
    
    func fetchTodos(onCompletion completion: @escaping (_ result: Result<[Todo], Error>) -> Void ) {
        
        let decoder = createDecoderForMongoDates()
        
        AF.request(baseURL).validate().responseDecodable(decoder: decoder) { (response: DataResponse<TodoResponse>) in
            switch self.handleErrors(forTodoDataResponse: response) {
            case .success(let todos): completion(.success(todos))
            case .failure(let error): completion(.failure(error))
            }

        }
    }
    
    private func createDecoderForMongoDates() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom() { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = df.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Couldn't convert date")
            }
        }
        return decoder
    }
    
    private func handleErrors(forTodoDataResponse response: DataResponse<TodoResponse>) -> Result<[Todo], Error> {
        switch response.result {
        case .failure(let error): return .failure(error)
        case .success(let todoResponse):
            if todoResponse.success {
                
                if let todo = todoResponse.todo {
                    return .success([todo])
                } else if let todos = todoResponse.todos {
                    return .success(todos)
                } else {
                    return .failure(NSError(domain: "Invalid Response", code: 0000))
                }
            } else {
                
                if let error = todoResponse.error {
                    return .failure(NSError(domain: error, code: 0000))
                } else {
                    return .failure(NSError(domain: "Invalid Response", code: 0000))
                }
            }
        }
    }
    
}

protocol TodoDataProvider {
    //TODO: Change Return types to allow failure reporting
    
    func fetchTodos(onCompletion completion: @escaping (_ result: Result<[Todo], Error>) -> Void)
    
    func addTodo(withValues: [TodoFields: Encodable], andOnCompletion completion: @escaping (_ result: Result<Todo, Error>) -> Void)
    
    func updateTodo(withID: String, withNewValues: [TodoFields: Encodable])
    
    func deleteTodo(withID: String)
}

fileprivate class TodoParameters: Encodable {
    var title: String
    init?(withFieldsDict dict: [TodoFields:Encodable]) {
        if let t = dict[.title] as? String {
            self.title = t
        } else {
            return nil
        }
    }
    
}
enum TodoFields: String, Hashable {
    case title
    case categoryIDs
    
}


