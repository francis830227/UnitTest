//
//  JSONHelper.swift
//  UniTestDemo
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import Foundation

struct JSONHelper {
    
    enum LoadJSONResult {
        
        case success(Any)
        
        case failure(Error)
        
    }
    
    typealias LoadJSONCompletion = (_ result: LoadJSONResult) -> Void
    
    enum LoadJSONError: Error {
        
        case fileNotFound
        
    }
    
    func loadJSON(name: String, completion: @escaping LoadJSONCompletion) {
     
        DispatchQueue.global(qos: .background).async {
            
            guard
                let filePath = Bundle.main.path(
                forResource: name,
                ofType: "json"
                )
                else {
                    
                    // failure
                    
                    DispatchQueue.main.async {
                        
                        completion(
                        
                            .failure(LoadJSONError.fileNotFound)
                        )
                    }
                    
                    return
                    
            }
            
            let fileURL = URL(fileURLWithPath: filePath)
            
            do {
                
                let data = try Data(contentsOf: fileURL)
                
                let json = try JSONSerialization.jsonObject(with: data)
                
                DispatchQueue.main.async {
                    completion(
                        
                        .success(json)
                        
                    )
                }
                
            } catch {
            
                DispatchQueue.main.async {
                    
                    completion(
                        .failure(error)
                    )
                }
            }
            
        }
        
    }
    
}
