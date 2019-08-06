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
    
    func addTodo(withValues values: [TodoFields: Any]) -> Todo{
        return Todo(title: values[.title] as! String, id: UUID().uuidString)
    }
    
    func updateTodo(withID: String, toMatch: Todo) {
        
    }
    
    func deleteTodo(withID: String) {
        
    }
    
    func fetchTodos(onCompletion completion: @escaping (_ result: Result<[Todo], Error>) -> Void ) {
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
        
        AF.request(baseURL).validate().responseDecodable(decoder: decoder) { (response: DataResponse<[Todo]>) in
            switch response.result {
            case .success(let data): completion(.success(data))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

protocol TodoDataProvider {
    //TODO: Change Return types to allow failure reporting
    
    func fetchTodos(onCompletion completion: @escaping (_ result: Result<[Todo], Error>) -> Void)
    
    func addTodo(withValues: [TodoFields: Any]) -> Todo
    
    func updateTodo(withID: String, toMatch: Todo)
    
    func deleteTodo(withID: String)
}

enum TodoFields: Hashable {
    case title
}
