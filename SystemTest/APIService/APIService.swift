//
//  APIService.swift
//  SystemTest
//
//  Created by Ramesh Maddali on 18/12/22.
//

import UIKit

class APIService: NSObject {
    
    func getRandomCatFact(_ serviceUrl: String ,_ params: [String:Any]?,_ methodType: String?, _ completionHandler: @escaping (_ data:RandomCatFact?,_ error:Error?)->Void) {
        var serviceUrlformat:String = ""
        if methodType == GET_REQUEST {
            serviceUrlformat = String(format:"%@%@",serviceUrl,getQueryString(params: params))
        }
        let set = CharacterSet.urlQueryAllowed
        guard let encodedUrlAsString = serviceUrlformat.addingPercentEncoding(withAllowedCharacters: set) else { return }
        let urlPoint=URL(string:encodedUrlAsString)
        guard let url = urlPoint  else { return }
        
        let request = getURLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let urlResponse = response as? HTTPURLResponse , urlResponse.statusCode == 404 {
                    completionHandler(nil, nil)
                return
            }
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let responseData = try jsonDecoder.decode(RandomCatFact.self, from: responseData)
                completionHandler(responseData, error)
            }
            catch let error {
                print("Error while converting data to JSON")
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
    func getRandomCatImage(_ url: String, _ completionHandler: @escaping (_ imageData:Data?,_ error:Error?)->Void) {
        guard let imageUrl = URL(string: url) else { return }
        getDataFromUrl(url: imageUrl) { data, _, error in
            completionHandler(data, error)
        }
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    private func getURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url:url)
        request.timeoutInterval = TimeInterval(REQUEST_TIMEOUT)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = GET_REQUEST
        return request
        
    }
    
    private func getQueryString(params : [String : Any]?)-> String {
        guard let params = params else {return ""}
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        var urlString = "?" + urlParams
        if let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            urlString = url
        }
        return urlString
    }
}
