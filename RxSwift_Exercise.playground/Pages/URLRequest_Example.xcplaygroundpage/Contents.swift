import Foundation
import UIKit

//let url:URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//let url:URL = URL(string: "https://httpstat.us/404")!
//
//let task = URLSession.shared.dataTask(with: url){data,response,error in
//    if let error = error {
//        debugPrint("Error Message:",error.localizedDescription)
//    } else if
//        let data = data,
//        let response = response as? HTTPURLResponse{
//        debugPrint("response statusCode:",response.statusCode)
////        debugPrint("data:",String(data: data, encoding: .utf8))
//        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//            print("Server error!")
//            return
//        }
//
//    }
//}
//task.resume()


let baseGetURL = "https://httpbin.org/get"
let basePostURL = "https://httpbin.org/post"


let getParameters = ["para1":"value1","para2":"value2"]
let getHeaders = ["header1":"value1","header2":"value2"]
let postJSON = ["para1":"value1","para2":"value2"]
let postURLencoded = "para1=value1&para2%5Bvalue21%5D=value22"
let postFormData = ["para1":"value1"]
//傳統URLSession
//MARK:Http Get


//純GET
func requestWithURL0(urlString: String, completion: @escaping (Data) -> Void){
                
    let request = URLRequest(url: URL(string: urlString)!)

    fetchedDataByDataTask(from: request, completion: completion)
}

//GET帶參數
func requestWithURL(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void){
        
    var urlComponents = URLComponents(string: urlString)!
    urlComponents.queryItems = []
    
    for (key, value) in parameters{
        guard let value = value as? String else{return}
        urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
    }
    
    guard let queryedURL = urlComponents.url else{return}
    
    let request = URLRequest(url: queryedURL)
    
    fetchedDataByDataTask(from: request, completion: completion)
}

func requestWithHeader(urlString: String, parameters: [String: String], completion: @escaping (Data) -> Void){
        
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    
    for (key, value) in parameters{
        request.addValue(value, forHTTPHeaderField: key)
    }
    fetchedDataByDataTask(from: request, completion: completion)
    
}

func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> ()){
    let task = URLSession.shared.dataTask(with: request){
        (data, response, error) in
        
        if let error = error {
            debugPrint("Error Message:",error.localizedDescription)
        } else if
            let data = data,
//            let response = response as? HTTPURLResponse{
//            debugPrint("response statusCode:",response.statusCode)
////            debugPrint("data:",String(data: data, encoding: .utf8))
//            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//                print("Server error!")
//                return
//            }

            let response = response as? URLResponse, let httpResponse = response as? HTTPURLResponse{
            let jsonString = String(data: data, encoding: .utf8)
            
//            debugPrint("response statusCode:",httpResponse.statusCode)
//            debugPrint("jsonString:\(jsonString)")
            
//            debugPrint("response text:",response)
//            debugPrint("response expectedContentLength:",response.expectedContentLength)
//            debugPrint("response mimeType:",response.mimeType)
//            debugPrint("response textEncodingName:",response.textEncodingName)
//            debugPrint("response suggestedFilename:",response.suggestedFilename)
            
            
            completion(data)

        }

    }
    
    task.resume()
}

//requestWithURL0(urlString: "https://httpbin.org/get") { data in
//    debugPrint("data0:",String(data: data, encoding: .utf8))
//
//}


requestWithURL(urlString: "https://httpbin.org/get", parameters: [:]) { data in
//    debugPrint("data1:",String(data: data, encoding: .utf8))
}

requestWithHeader(urlString: "https://httpbin.org/get", parameters: getHeaders) { data in
//    debugPrint("header data2:",String(data: data, encoding: .utf8))
}

//MARK:Http Post

//Post 使用json body，content-type為application/json

func requestWithJSONBody(urlString: String, parameters: [String: Any], completion: @escaping (Data) -> Void){
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    
    do{
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
    }catch let error{
        print(error)
    }
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    fetchedDataByDataTask(from: request, completion: completion)
}


requestWithJSONBody(urlString: basePostURL, parameters: postJSON) { data in
//    debugPrint("post data0:",String(data: data, encoding: .utf8))
}


//POST content-type為application/x-www-form-urlencoded
func requestWithUrlencodedBody(urlString: String, parameters: String, completion: @escaping (Data) -> Void){
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpBody = parameters.data(using: String.Encoding.utf8)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    fetchedDataByDataTask(from: request, completion: completion)
    
}


requestWithUrlencodedBody(urlString: basePostURL, parameters: postURLencoded) { data in
    debugPrint("post data1:",String(data: data, encoding: .utf8))

}


//POST content-type為multipart/form-data，上傳一個照片
func requestWithFormData(urlString: String, parameters: [String: Any], dataPath: [String: Data], completion: @escaping (Data) -> Void){
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let boundary = "Boundary+\(arc4random())\(arc4random())"
    var body = Data()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    for (key, value) in parameters {
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString(string: "\(value)\r\n")
    }
    
    for (key, value) in dataPath {
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n") //此處放入file name，以隨機數代替，可自行放入
        body.appendString(string: "Content-Type: image/png\r\n\r\n") //image/png 可改為其他檔案類型 ex:jpeg
        body.append(value)
        body.appendString(string: "\r\n")
    }
    
    body.appendString(string: "--\(boundary)--\r\n")
    request.httpBody = body
    
    fetchedDataByDataTask(from: request, completion: completion)
    
}


extension Data{
    func parseData() -> NSDictionary{
        
        let dataDict = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as! NSDictionary
        
        return dataDict!
    }
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


//URLRequest
//URLSession
//Json Parser

let testUrl = URL(string: baseGetURL)
//var testRequest = URLRequest(url: testUrl!,cachePolicy: .returnCacheDataElseLoad,timeoutInterval: 3)

var testRequest = URLRequest(url: testUrl!)

testRequest.cachePolicy = .returnCacheDataElseLoad//快取屬性設定

testRequest.httpMethod = "POST"
testRequest.httpBody
testRequest.httpBodyStream
testRequest.mainDocumentURL
testRequest.url
//testRequest.timeoutInterval


testRequest.allHTTPHeaderFields = ["Content-type":"application/json"]
testRequest.addValue("aaa", forHTTPHeaderField: "111")
testRequest.setValue("bbb", forHTTPHeaderField: "222")
testRequest.value(forHTTPHeaderField: "111")
testRequest.value(forHTTPHeaderField: "222")

