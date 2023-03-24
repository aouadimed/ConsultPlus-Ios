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
    
    let baseUrl = "http://172.17.0.245:5000/"
   
    struct UserResponse: Codable {
        let email: String?
        let user: String?
        let role: String?
        let id: String?
        let name: String?
        let password: String?
        let genders: String?
        let birthdate: String?
        let adresse: String?
        let firstname: String?
        let lastname: String?
        let specialite: String?
        let experience: Int?
        let patient: Int?
        let description: String?
        let image: String?

    }

    func callingLoginApi(Login: UserModel, completionHandler : @escaping Handler) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"login", method: .post, parameters: Login, encoder: JSONParameterEncoder.default, headers: headers ).responseData { response in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(UserResponse.self, from: data)
                    print(userResponse)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(userResponse))
                    } else {
                        completionHandler(.failure(.custom(message: "Please recheck your credentials")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try again")))
                
                
                
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
    
    func callingUpdateApi(Update: UserModel, completionHandler : @escaping Handler)
    {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"edituser", method: .post, parameters: Update, encoder: JSONParameterEncoder.default, headers: headers ).response{
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
                       completionHandler(.failure(.custom(message: "Somthing rong")))
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
    
    
    func callingUserDataApi(UserData: UserModel, completionHandler : @escaping Handler) {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"userdata", method: .post, parameters: UserData, encoder: JSONParameterEncoder.default, headers: headers ).responseData { response in
            debugPrint(response)
            
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let userResponse = try decoder.decode(UserResponse.self, from: data)
                    print(userResponse)
                    
                    if response.response?.statusCode == 200 {
                        completionHandler(.success(userResponse))
                    } else {
                        completionHandler(.failure(.custom(message: "Please recheck your email")))
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.custom(message: "Please try again")))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(.failure(.custom(message: "Please try again")))
                
                
                
            }
        }
    }
    
    func callingUpdateDocteurApi(Update: UserModel, completionHandler : @escaping Handler)
    {
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(baseUrl+"editmedecin", method: .post, parameters: Update, encoder: JSONParameterEncoder.default, headers: headers ).response{
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
                       completionHandler(.failure(.custom(message: "Somthing rong")))
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
    
    func uploadImage(_ image: UIImage, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImagePicker", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])))
            return
        }
        
        let headers: HTTPHeaders = [
            .contentType("multipart/form-data")
        ]
        
        let url = baseUrl + "ImageUpload"
        
        let uuid = UUID().uuidString
        let timestamp = Int(Date().timeIntervalSince1970)
        let filename = "\(timestamp)-\(uuid).png"
        
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directoryUrl = documentsUrl.appendingPathComponent("ConsultPlus")
            if !FileManager.default.fileExists(atPath: directoryUrl.path) {
                try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            } else {
                let fileUrls = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [])
                for fileUrl in fileUrls {
                    try FileManager.default.removeItem(at: fileUrl)
                    print(fileUrl)
                }
            }
            let fileUrl = directoryUrl.appendingPathComponent(filename)
            print(fileUrl)
            try imageData.write(to: fileUrl)
        } catch {
            completion(.failure(error))
            return
        }

        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "upload", fileName: filename, mimeType: "image/jpeg")
            multipartFormData.append(email.data(using: .utf8)!, withName: "email")
        }, to: url, headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImage(email: String,imageName :String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentsURL.appendingPathComponent("ConsultPlus")
        let fileURL = directoryURL.appendingPathComponent("\(imageName)")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            completion(.success(true))
            return
        }
        
        let downloadRequest = AF.download(baseUrl+"getImage/\(email)").responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    // Create the directory if it doesn't exist
                    try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                    // Write the downloaded data to the file URL
                    try data.write(to: fileURL)
                    completion(.success(true))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        // Start the download request
        downloadRequest.resume()
    }



}




