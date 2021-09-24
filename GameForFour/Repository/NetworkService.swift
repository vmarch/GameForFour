//
//  NetworkService.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

import Foundation
class NetworkService{
    class func connectToServer(url: URL, bodyDataText: String, completion: @escaping (Data?, Error?) -> ()){
        
        let url = url
        var request = URLRequest(url: url)
      
        request.httpMethod = "POST"
        // request.httpMethod = "GET"
        
        let bodyData: String = bodyDataText
        request.httpBody = bodyData.data(using: .utf8)
        
        let dataTask = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            completion(data,nil)
            
        }
        dataTask.resume()
    }
    
    class func clearRoomOnServer(url: URL){
        let dataTask = URLSession.shared.dataTask(with: url)
        dataTask.resume()
    }
}
