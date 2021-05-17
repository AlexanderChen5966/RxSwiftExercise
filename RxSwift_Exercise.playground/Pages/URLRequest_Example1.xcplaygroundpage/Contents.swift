
import Foundation
import PlaygroundSupport
import Combine
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

struct Post: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case userIdentifier = "userId"
    }

    let id: Int
    let title: String
    let body: String
    let userIdentifier: Int
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
var request = URLRequest(url: url)

//The traditional way：URLSession
func fetchedDataByDataTask(from request: URLRequest){
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            
            print("Error: \(error.localizedDescription)")
            PlaygroundPage.current.finishExecution()
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Error: invalid HTTP response code")
            PlaygroundPage.current.finishExecution()
        }
        guard let data = data else {
            print("Error: missing data")
            PlaygroundPage.current.finishExecution()
        }

        // feel free to uncomment this for debugging data
        // print(String(data: data, encoding: .utf8))
        guard let jsonString = String(data: data, encoding: .utf8) else {
            return
        }
        jsonParser(jsonString: jsonString)
        
//        jsonParser(jsonData: data)
        
//        do {
//            let decoder = JSONDecoder()
//            let posts = try decoder.decode([Post].self, from: data)
//
//            print(posts.map { $0.title })
//            PlaygroundPage.current.finishExecution()
//        }
//        catch {
//            print("Error: \(error.localizedDescription)")
//            PlaygroundPage.current.finishExecution()
//        }
    }.resume()

}


public typealias JsonDictionary = [String: Any]

func jsonParser(jsonString: String?) {
//func jsonParser(jsonData: Data?) {

    guard let data = jsonString?.data(using: String.Encoding.utf8) else {
        return
    }
    
    do
    {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//        print("jsonObject:\(jsonObject)")
        
        if let stringArray = jsonObject as? [Any] {
           print("stringArray:\(stringArray)")
        }
        
//        switch jsonObject {
//
//        case let jsonDictionary as JsonDictionary:
//            print("jsonDictionary:\(jsonDictionary)")
//
//        default:
//            print("\r\nJson反序列化(未實作的Type): \r\n\(type(of: jsonObject))")
//
//            break
//        }
    }
    catch let error
    {
            print("\r\nJson反序列化(catch error): \r\n\(error.localizedDescription)")
    }

}
//(key "body", value "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
//fetchedDataByDataTask(from: request)

//Data task with Combine
private var cancellable: AnyCancellable?
//...
//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//.map { $0.data }
//.decode(type: [Post].self, decoder: JSONDecoder())
//.replaceError(with: [])
//.eraseToAnyPublisher()
//.sink(receiveValue: { posts in
//    print(posts.count)
//})
//...
//cancellable?.cancel()



//Error handling
enum HTTPError: LocalizedError {
    case statusCode
    case post

}
//
cancellable = URLSession.shared.dataTaskPublisher(for: url)
.tryMap { output in
    guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
        throw HTTPError.statusCode
    }
    return output.data
}
.decode(type: [Post].self, decoder: JSONDecoder())
.eraseToAnyPublisher()
.sink(receiveCompletion: { completion in
    switch completion {
    case .finished:
        break
    case .failure(let error):
        fatalError(error.localizedDescription)
    }
}, receiveValue: { posts in
    print(posts.count)
})



//Assign result to property
//class AAA {
//    static let shared = AAA()
//
//    var posts: [Post] = [] {
//        didSet {
//            print("posts --> \(posts.count)")
//        }
//    }
//
//}
//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//        .map { $0.data }
//        .decode(type: [Post].self, decoder: JSONDecoder())
//        .replaceError(with: [])
//        .eraseToAnyPublisher()
//        .assign(to: \.posts,on: AAA.shared)
        
//
//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//    .map{ $0.data }
//    .decode(type: [Post].self, decoder: JSONDecoder())
//    .replaceError(with: [])
//    .receive(on: RunLoop.main)
//    .assign(to: \.posts, on: AAA.shared)
//PlaygroundPage.current.finishExecution()



//Request dependency

var posts1: [Post] = [] {
    didSet {
        print("posts1 --> \(posts1.count)")
    }
}

//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//.map { $0.data }
//.decode(type: [Post].self, decoder: JSONDecoder())
////.tryMap { posts in
////    guard let id = posts.first?.id else {
////        throw HTTPError.post
////    }
////    return id
////}
//.replaceError(with: [])
//.sink(receiveCompletion: { completion in
////    print("completion:",completion)
//
//}) { post in
//    posts1 = post
//}


//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//.map { $0.data }
//.decode(type: [Post].self, decoder: JSONDecoder())
//.tryMap { posts in
//    guard let id = posts.first?.id else {
//        throw HTTPError.post
//    }
//    return id
//}
//.flatMap { id in
//    return details(for: id)
//}
//.sink(receiveCompletion: { completion in
////    print("completion:",completion)
//
//}) { post in
//    print("post.title:",post.title)
//
//}


//func details(for id: Int) -> AnyPublisher<Post, Error> {
//    print("id:",id)
//    let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
//    return URLSession.shared.dataTaskPublisher(for: url)
//        .mapError { $0 as Error }
//        .map { $0.data }
//        .decode(type: Post.self, decoder: JSONDecoder())
//        .eraseToAnyPublisher()
//}

//
//let myRange = 0...3
//cancellable = myRange.publisher
//    .sink(receiveCompletion: {
//
//    print("completion:\($0)")
//}, receiveValue: {
//    print("value:\($0)")
//
//})

//cancellable = URLSession.shared.dataTaskPublisher(for: url)
//.map { $0.data }
//.decode(type: [Post].self, decoder: JSONDecoder())
//.sink(receiveCompletion: { completion in
//    print("completion:",completion)
//
//}) { post in
//    posts1 = post
//    PlaygroundPage.current.finishExecution()
//}



enum PasswordError: Error {
    case wrongPassword
    case emptyPassword
}
func getAnswer(password: String) throws -> String {
    guard password.isEmpty == false else {
        throw PasswordError.emptyPassword
    }
    guard password == "deeplove" else {
        throw PasswordError.wrongPassword
    }
    return "只有用心看才看得清楚，重要的東西是眼睛看不見的"
}
do {
    let answer = try getAnswer(password: "deeplove")
    print(answer)
} catch PasswordError.wrongPassword {
    print("wrongPassword")
} catch PasswordError.emptyPassword {
    print("emptyPassword")
} catch {
    print("other error")
}



//在 completionHandler 的 closure throw 錯誤將造成問題，因為 completionHandler 的型別是 (Data?, URLResponse?, Error?) -> Void
//enum NetworkError: Error {
//    case invalidUrl
//    case requestFailed
//}
//func downloadImage(urlString: String) throws {
//    guard let url = URL(string: urlString) else {
//        throw NetworkError.invalidUrl
//    }
//    URLSession.shared.dataTask(with: url) { (data, response, error) in
//        if let error = error {
//            throw NetworkError.requestFailed //＊此處會發生問題
//        }
//    }.resume()
//}


//傳統URLSession抓資料的寫法
enum NetworkError: Error {
    case invalidUrl
    case requestFailed(Error)
    case invalidData
    case invalidResponse
}
func downloadImage(urlString: String, completion: @escaping (UIImage?, NetworkError?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("invalidUrl")
        completion(nil, .invalidUrl)
        return
    }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, .requestFailed(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(nil, .invalidResponse)
            return
        }
        guard let data = data, let image = UIImage(data: data) else {
            completion(nil, .invalidData)
            return
        }
        completion(image, nil)
    }.resume()
}

downloadImage(urlString: "https://images-na.ssl-images-amazon.com/images/I/61Zi2jjgfIL.jpg") { (image, error) in
    if let image = image {
        print(image)
    } else if let error = error {
        print(error)
    }
}



//在URLSession的例子中使用Result type
func resultTypeDownloadImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
    
    guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
    }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(.failure(.invalidResponse))
            return
        }
        guard let data = data, let image = UIImage(data: data) else {
            completion(.failure(.invalidData))
            return
        }
        completion(.success(image))
    }.resume()
}


resultTypeDownloadImage(urlString: "https://images-na.ssl-images-amazon.com/images/I/61Zi2jjgfIL.jpg") { (result) in
    switch result {
    case .success(let image):
        print(image)
    case .failure(let networkError):
        switch networkError {
        case .invalidUrl:
            print(networkError)
        case .requestFailed(let error):
            print(networkError, error)
        case .invalidData:
            print(networkError)
        case .invalidResponse:
            print(networkError)
        }
    }
}


let urlString = "https://jsonplaceholder.typicode.com/posts"
let httpUrl = URL(string: urlString)!
let urlRequest = URLRequest(url: httpUrl)
let sessionTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Error: invalid HTTP response code")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    //Json Parse

}
sessionTask.resume()


URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Error: invalid HTTP response code")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    //Json Parse

}.resume()




URLSession.shared.dataTask(with: httpUrl) { (data, response, error) in
    
    if let error = error {
        print("Error: \(error.localizedDescription)")
    }
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Error: invalid HTTP response code")
        return
    }
    guard let data = data else {
        print("Error: missing data")
        return
    }
    //Json Parse

}.resume()


func urlSession(urlString:String,completion: @escaping (Data?, NetworkError?) -> ()) {
    guard let url = URL(string: urlString) else {
        //不正確的URL格式
        return completion(nil, .invalidUrl)
    }
    
    //URL正確就發請求
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, .requestFailed(error))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            //statusCode非200就發錯誤訊息
            completion(nil, .invalidResponse)
            return
        }
        guard let data = data else {
            //statusCode 200但是沒取得資料
            completion(nil, .invalidData)
            return
        }
        completion(data, nil)

    }
    
}


//使用Result取代原本的Error
func urlSessionWithResultType(urlString:String,completion: @escaping (Result<Data, NetworkError>) -> ()) {
    guard let url = URL(string: urlString) else {
        //不正確的URL格式
        return completion(.failure(.invalidUrl))
    }
    
    //URL正確就發請求
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            return completion(.failure(.requestFailed(error)))
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            //statusCode非200就發錯誤訊息
            return completion(.failure(.invalidResponse))
        }
        guard let data = data else {
            //statusCode 200但是沒取得資料
            return completion(.failure(.invalidData))
        }
        completion(.success(data))

    }
}

//let testUrl = URL(string: "https://httpstat.us/404")!
//
//URLSession.shared
//    .dataTaskPublisher(for: testUrl)
//    .map{ (data, response) -> Result<Data, NetworkError> in
//
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            //statusCode非200就發錯誤訊息
//                print("statusCode非200")
//            return .failure(.invalidResponse)
//        }
////        guard let data = data else {
//            //statusCode 200但是沒取得資料
////            return .failure(.invalidData)
////        }
//        return .success(data)
//    }
//    .eraseToAnyPublisher()

let urlString1 = "https://jsonplaceholder.typicode.com/posts"
//let urlString1 = "https://jsonplaceholder.typicode.com/users/1"
//let urlString1 = "https://httpstat.us/404"

let url1 = URL(string: urlString1)!
var request1 = URLRequest(url: url1)
public struct WebAPIModelElement: Codable {
    public let userId:Int?
    public let id:Int
    public let title:String
    public let body:String?

}


//let subscription = URLSession.shared
//  .dataTaskPublisher(for: url)
//  .tryMap { data, _ in
//    try JSONDecoder().decode([WebAPIModelElement].self, from: data)
//  }
//  .sink(receiveCompletion: { completion in
//    if case .failure(let err) = completion {
//      print("Retrieving data failed with error \(err)")
//    }
//  }, receiveValue: { object in
//    print("Retrieved object \(object)")
//  })

let publisher2 = URLSession.shared
  .dataTaskPublisher(for: request1)
    .map(\.data)
    .decode(type: [WebAPIModelElement].self, decoder: JSONDecoder())
    .eraseToAnyPublisher()



let publisher = URLSession.shared
// 1
    .dataTaskPublisher(for: request1)
    .map(\.data)
    .eraseToAnyPublisher()


//let subscription1 = publisher.sink(receiveCompletion: { completion in
//    if case .failure(let err) = completion {
//      print("Sink1 Retrieving data failed with error \(err)")
//    }
//  }, receiveValue: { object in
//    print("Sink1 Retrieved object \(object)")
//  })

//let subscription2 = publisher2.sink(receiveCompletion: { completion in
//    if case .failure(let err) = completion {
//      print("Sink1 Retrieving data failed with error \(err)")
//    }
//  }, receiveValue: { object in
//    print("Sink1 Retrieved object \(object.first?.id)")
//  })


public protocol Request {
    var request: URLRequest { get }
    associatedtype ResponseObject:Codable
}

struct TESTRequest: Request {
    var request: URLRequest

    typealias ResponseObject = [WebAPIModelElement]

}

func fetchCallAPI<T: Request>(r:T) -> AnyPublisher<T.ResponseObject,Error>{
    
    return URLSession.shared
        .dataTaskPublisher(for: r.request)
        .map(\.data)
        .decode(type: T.ResponseObject.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

let request2 = TESTRequest(request: request1)
//let subscription3 = fetchCallAPI(r: request2).sink(receiveCompletion: { completion in
//        if case .failure(let err) = completion {
//          print("Sink1 Retrieving data failed with error \(err)")
//        }
//      }, receiveValue: { object in
//        print("Sink1 Retrieved object \(object.first?.id)")
//      })



let publisher3 =  URLSession.shared
    .dataTaskPublisher(for: request1)
    .tryMap { output in
        guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
            debugPrint("非200")
            throw HTTPError.statusCode
        }
        debugPrint("200")

        return output.data
    }
    .decode(type: [WebAPIModelElement].self, decoder: JSONDecoder())
    .eraseToAnyPublisher()
    
let publisher4 =  URLSession.shared
    .dataTaskPublisher(for: request1)
    .map( { (data, response) -> Result<Any, HTTPError>  in
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            debugPrint("非200")
            return .failure(HTTPError.statusCode)
        }
        debugPrint("200")
        return .success(data)
    })
    .eraseToAnyPublisher()


let subscription5 = publisher4.sink { (completion) in
    switch completion {
    case .finished:
        print("finished")
        break
    case .failure(let error):
        print(error.localizedDescription)
    }

} receiveValue: { (result) in
    switch result {
    case .success(let data):
        guard let jsonString = String(data: data as! Data, encoding: .utf8) else {
            return
        }

        print(data)
        
    
    default:
        print("Status Code Not 200")
        break
    }
}


//let subscription4 = publisher3.sink(receiveCompletion: { completion in
//    switch completion {
//    case .finished:
//        break
//    case .failure(let error):
//        print(error.localizedDescription)
//    }
//}, receiveValue: { data in
//    print(data.first?.id)
//})
