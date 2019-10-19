//
//  CategoryModelController.swift
//  ToDoApp
//
//  Created by Jack Adams on 18/08/2019.
//  Copyright © 2019 Jack Adams. All rights reserved.
//

import Foundation

class CategoryModelController {
    
    private(set) static var shared = CategoryModelController()
    
    private var categories = [Category]()
    private let categoryDataProvider: CategoryDataProvider
    public var numberOfCategories: Int {
        return categories.count
    }
    
    init (categoryDataProvider: CategoryDataProvider? = nil) {
        self.categoryDataProvider = categoryDataProvider ?? NetworkCategoryDataProvider()
    }
    
    func fetchCategories(inDispatchGroup group: DispatchGroup) {
        group.enter()
        categoryDataProvider.fetchCategories() { result in
            switch result {
            case .success(let categories):
                self.categories = categories
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            group.leave()
        }
    }
    
    func addCategory(withValues values: [CategoryFields:Encodable], onCompletion completion: @escaping (_ result: Result<Category, Error>) -> Void) {
        
        categoryDataProvider.addCategory(withValues: values) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let category):
                    self.categories += [category]
                    completion(.success(category))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
            
            
        }
    }
    
    public func getAllCategoryViewModels(forDisplayingOnMenu menu: Bool = false) -> [CategoryViewModel] {
        return categories.map({return CategoryViewModel(category: $0, onMenu: menu)})
    }
    
    public func getCategoryViewModel(atIndex index: Int, forDisplayingOnMenu menu: Bool = false) -> CategoryViewModel {
        return CategoryViewModel(category: categories[index], onMenu: menu)
    }
    
    public func getCategoryViewModel(withID id: String, forDisplayingOnMenu menu: Bool = false) -> CategoryViewModel? {
        if let index = categories.firstIndex(where: { $0.id == id }) {
            return CategoryViewModel(category: categories[index], onMenu: menu)
        } else {
            return nil
        }
    }
    
    public func deleteCategory(withID id: String) {
        
        categoryDataProvider.deleteCategory(withID: id)
        categories.removeAll() { $0.id == id }
    }
    
    public func editCategory(withID id: String, andNewValues newValues: [CategoryFields:Encodable], onCompletion completion: @escaping (_ result: Result<Category, Error>) -> Void) {
        categoryDataProvider.updateCategory(withID: id, withNewValues: newValues) { result in
            switch result {
            case .success(let newCategory):
                if let index = self.categories.firstIndex(where: { $0.id == newCategory.id}) {
                    self.categories[index] = newCategory
                }
                
            default:
                break
            }
            completion(result)
        }
    }
    
}
