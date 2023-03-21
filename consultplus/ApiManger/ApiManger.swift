//
//  ApiManger.swift
//  consultplus
//
//  Created by Mohamed Aouadi on 21/3/2023.
//

import Foundation
import Alamofire
import SwiftyJSON

enum APIErrors: Error{
    case custom(message : String)
}

//

typealias Handler = (Swift.Result<Any?, APIErrors>)-> Void


class ApiManager{
    static let shareInstance = ApiManager()
    
    let baseUrl = "http://172.17.1.3:5000/"


    func callingLoginApi(Login: UserModel, completionHandler : @escaping Handler)
    {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"login", method: .post, parameters: Login, encoder: JSONParameterEncoder.default, headers: headers ).response{
            response in debugPrint(response)
            
            switch response.result{
            case .success(let data):
               do {
                   let json = try JSONSerialization.jsonObject(with: data!, options: [])
                   print(json)
                   if response.response?.statusCode == 200{
                       completionHandler(.success(json))
                   }
                   else {
                       completionHandler(.failure(.custom(message: "Please recheck your credentials")))
                   }
                
               }catch{
                   print(error.localizedDescription)
                   completionHandler(.failure(.custom(message: "Please try again")))
                   
               }
            case .failure(let err) :
                print(err.localizedDescription)
                
            }
        }
    }
    
    func callingRegisterApi(Register: UserModel, completionHandler : @escaping Handler)
    {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"register", method: .post, parameters: Register, encoder: JSONParameterEncoder.default, headers: headers ).response{
            response in debugPrint(response)
            
            switch response.result{
            case .success(let data):
               do {
                   let json = try JSONSerialization.jsonObject(with: data!, options: [])
                   print(json)
                   if response.response?.statusCode == 200{
                       completionHandler(.success(json))
                   }
                   else {
                       completionHandler(.failure(.custom(message: "Email aleardy exists")))
                   }
                
               }catch{
                   print(error.localizedDescription)
                   completionHandler(.failure(.custom(message: "Please try again")))
                   
               }
            case .failure(let err) :
                print(err.localizedDescription)
                
            }
        }
    }

}




