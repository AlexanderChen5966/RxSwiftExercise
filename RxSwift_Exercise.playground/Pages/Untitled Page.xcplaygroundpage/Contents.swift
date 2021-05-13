import RxSwift
import RxCocoa
import RxSwiftExt
import PlaygroundSupport
import UIKit
import Foundation


let disposeBag = DisposeBag()

public struct WebAPIModelElement: Codable {
    public let userId:Int?
    public let id:Int
    public let title:String
    public let body:String?

}

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}



class APIClient {
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/")!
    
    func getAPI<T: Codable>() -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

let apiClient = APIClient()


//final class ReachedBottomViewController: UITableViewController {
//    private let dataSource = Array(stride(from: 0, to: 28, by: 1))
//    private let identifier = "identifier"
//    private let disposeBag = DisposeBag()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
//        tableView.rx.reachedBottom(offset: 40)
//            .subscribe(onDisposed:  { print("Reached bottom") })
//            .disposed(by: disposeBag)
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        cell.textLabel?.text = "\(dataSource[indexPath.row])"
//        return cell
//    }
//}

// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = ReachedBottomViewController()



public class RequestObservable {
  private lazy var jsonDecoder = JSONDecoder()
  private var urlSession: URLSession
  public init(config:URLSessionConfiguration) {
      urlSession = URLSession(configuration:
                URLSessionConfiguration.default)
  }
//MARK: function for URLSession takes
  public func callAPI<T: Decodable>(request: URLRequest)
    -> Observable<T> {
  //MARK: creating our observable
  return Observable.create { observer in
  //MARK: create URLSession dataTask
  let task = self.urlSession.dataTask(with: request) { (data,
                response, error) in
  if let httpResponse = response as? HTTPURLResponse{
  let statusCode = httpResponse.statusCode
  do {
    let _data = data ?? Data()
    if (200...399).contains(statusCode) {
//        print(statusCode)
//        print(httpResponse)

      let objs = try self.jsonDecoder.decode(T.self, from:
                          _data)
      //MARK: observer onNext event
//        print(objs)
      observer.onNext(objs)
    }
    else {
      observer.onError(error!)
    }
  } catch {
      //MARK: observer onNext event
      observer.onError(error)
     }
   }
     //MARK: observer onCompleted event
     observer.onCompleted()
   }
     task.resume()
     //MARK: return our disposable
     return Disposables.create {
       task.cancel()
     }
   }
  }
}


fileprivate extension Encodable {
  var dictionaryValue:[String: Any?]? {
      guard let data = try? JSONEncoder().encode(self),
      let dictionary = try? JSONSerialization.jsonObject(with: data,
        options: .allowFragments) as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}




class APIClient1 {
  static var shared = APIClient1()
  lazy var requestObservable = RequestObservable(config: .default)
    
  func getRecipes() -> Observable<[WebAPIModelElement]> {
    var request = URLRequest(url:
          URL(string:"https://jsonplaceholder.typicode.com/posts")!)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField:
              "Content-Type")
    return requestObservable.callAPI(request: request)
  }
  
  func sendPost(recipeModel: WebAPIModelElement) -> Observable<WebAPIModelElement> {
     var request = URLRequest(url:
          URL(string:"https://jsonplaceholder.typicode.com/posts")!)
     request.httpMethod = "POST"
     request.addValue("application/json", forHTTPHeaderField:
      "Content-Type")
     let payloadData = try? JSONSerialization.data(withJSONObject:
           recipeModel.dictionaryValue!, options: [])
     request.httpBody = payloadData
    
    return requestObservable.callAPI(request: request)
   }
}

  


final class TestViewController: UITableViewController {
    private let dataSource = Array(stride(from: 0, to: 28, by: 1))
    private let identifier = "identifier"
    private let disposeBag = DisposeBag()
    var postValue:[WebAPIModelElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        
        let client = APIClient1.shared
        let result : Observable<[WebAPIModelElement]> = client.getRecipes()

        
        _ = result.bind(to: tableView.rx.items(cellIdentifier: identifier)){
            ( row, model, cell) in
            cell.textLabel?.text = model.body
        }.disposed(by: disposeBag)
//        do{
//              try client.getRecipes().subscribe(
//                onNext: { result in
//                    print("APIClient1 result:",result.description)
//                    self.postValue = result
//                },
//                onError: { error in
//                   print("Error:",error.localizedDescription)
//                },
//                onCompleted: {
//                   print("Completed event.")
//        //            print("client:",postValue.first?.body)
//
//                }).disposed(by: disposeBag)
//          }
//          catch{
//          }

    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postValue.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        cell.textLabel?.text = "\(postValue[indexPath.row].title)"
//        return cell
//    }
}

//Present the view controller in the Live View window
//PlaygroundPage.current.liveView = TestViewController()


