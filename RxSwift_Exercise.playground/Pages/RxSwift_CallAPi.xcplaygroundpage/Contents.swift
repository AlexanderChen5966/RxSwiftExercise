import RxSwift
import RxCocoa
import PlaygroundSupport
import UIKit
import Foundation
import SnapKit

public struct WebAPIModelElement: Codable {
    public let userId:Int?
    public let id:Int
    public let title:String
    public let body:String?

}


//
//public enum RequestType: String {
//    case GET, POST, PUT,DELETE
//}
//
//class APIRequest {
//    let baseURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//    var method = RequestType.GET
//    var parameters = [String: String]()
//}
//
//extension APIRequest {
//    func request(with baseURL: URL) -> URLRequest {
//      var request = URLRequest(url: baseURL)
//       request.httpMethod = method.rawValue
//       request.addValue("application/json", forHTTPHeaderField: "Accept")
//       return request
//   }
//
//}
//
//class APICalling {
//    // create a method for calling api which is return a Observable
//    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
//        return Observable<T>.create { observer in
//            let request = apiRequest.request(with: apiRequest.baseURL)
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
////                    let model: WebAPIModelElement = try JSONDecoder().decode(WebAPIModelElement.self, from: data ?? Data())
////                    observer.onNext( model as! T)
//
//                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
//                    observer.onNext(model)
//
//                } catch let error {
//                    observer.onError(error)
//                }
//                observer.onCompleted()
//            }
//            task.resume()
//
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
//}
//
//
//final class TestViewController: UIViewController {
//    private let apiCalling = APICalling()
//    private let disposeBag = DisposeBag()
//    private let identifier = "identifier"
////    private var tableView = UITableView()
//
//    lazy var tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
//        return table
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        tableView.frame = self.view.frame
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
////        let request =  APIRequest()
////        let result : Observable<[WebAPIModelElement]> = self.apiCalling.send(apiRequest: request)
////        result.bind(to: tableView.rx.items(cellIdentifier: identifier)) { ( row, model, cell) in
////           cell.textLabel?.text = model.title
////        }
//        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.left.top.bottom.right.equalToSuperview()
//        }
//
//        bindTableView()
//    }
//
//    func bindTableView() {
//        // 1 初始化数据源
////        let items = Observable.just((0...30).map {"\($0)" })
////        // 2 绑定数据源到tableView
////        items.bind(to: tableView.rx.items(cellIdentifier: identifier)){ (row, element, cell) in
////            cell.textLabel?.text = "\(element)"
////            }
////            .disposed(by: disposeBag)
////        // 3 设置点击事件
////        tableView.rx.modelSelected(String.self).subscribe(onNext: {
////            print("tap index: \($0)")
////        }).disposed(by: disposeBag)
//
//        let request =  APIRequest()
//        let result : Observable<[WebAPIModelElement]> = self.apiCalling.send(apiRequest: request)
//        _ = result.bind(to: tableView.rx.items(cellIdentifier: identifier)) { ( row, model, cell) in
//           cell.textLabel?.text = model.title
//        }.disposed(by: disposeBag)
//
//    }
//
//}
//
//
//
//
//class ViewController: UIViewController {
//
//    let disposeBag = DisposeBag()
//
//    lazy var tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        return table
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addTableView()
//        bindTableView()
//    }
//
//    func addTableView() {
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            make.left.top.bottom.right.equalToSuperview()
//        }
//    }
//
//    func bindTableView() {
//        // 1 初始化数据源
//        let items = Observable.just((0...30).map {"\($0)" })
//        // 2 绑定数据源到tableView
//        items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)){ (row, element, cell) in
//            cell.textLabel?.text = "\(element)"
//            }
//            .disposed(by: disposeBag)
//        // 3 設置點擊事件
//        tableView.rx.modelSelected(String.self).subscribe(onNext: {
//            print("tap index: \($0)")
//        }).disposed(by: disposeBag)
//    }
//}
//
////TestViewController()
//PlaygroundPage.current.liveView = TestViewController()

//https://www.hangge.com/blog/cache/detail_2010.html
//"https://httpstat.us/404"
//"https://jsonplaceholder.typicode.com/posts"
//let urlString = "https://httpstat.us/500"
let urlString = "https://jsonplaceholder.typicode.com/posts"
//let urlString = "https://jsonplaceholder.typicode.com/users/1"

let url = URL(string: urlString)!
var request = URLRequest(url: url)
let disposeBag = DisposeBag()

//1 透過rx.response發出請求
//URLSession.shared.rx.response(request: request).subscribe { (response,data) in
//    if 200 ..< 300 ~= response.statusCode {
//        let str = String(data: data, encoding: String.Encoding.utf8)
//        debugPrint("rx.response請求成功，回傳資料為：\(str)")
//
//
//    } else {
//        debugPrint("請求失敗")
//    }
////    debugPrint("response:\(response) | data:\(str)")
//    PlaygroundPage.current.finishExecution()
//}.disposed(by: disposeBag)


//2 透過rx.data發出請求
//URLSession.shared.rx.data(request: request).subscribe(onNext:{
//    data in
//    let str = String(data: data, encoding: String.Encoding.utf8)
//
//    debugPrint("rx.data請求成功，回傳資料為：\(str)")
//}) { (error) in
//    debugPrint("請求失敗:\(error)")
//}.disposed(by: disposeBag)


//rx.response與rx.data的區別
//如果不需要底層的response資訊，只需要請求成功時的結果，就建議使用rx.data
//rx.data會自動判斷http status code，只有200~300的status code才會進入，onNext的call back，否則都會進入onError的call back


//將結果轉能Json的對象
//URLSession.shared.rx.data(request: request).subscribe(onNext:{
//    data in
//    let json  = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//    debugPrint("請求成功，回傳資料為：\(json)")
//}) { (error) in
//    debugPrint("請求失敗:\(error)")
//}.disposed(by: disposeBag)

//可以在subscribe之前就先進行轉換
//URLSession.shared.rx.data(request: request)
//    .map{
//        try JSONSerialization.jsonObject(with: $0, options: .allowFragments)
//                    as! [Any]
//    }
//    .subscribe(onNext:{
//    data in
//    debugPrint("請求成功，回傳資料為：\(data)")
//}) { (error) in
//    debugPrint("請求失敗:\(error)")
//}.disposed(by: disposeBag)

//使用RxSwift提供的rx.json來取得資料
//URLSession.shared.rx.json(request: request).subscribe(onNext:{
//    data in
//    let json = data as! [Any]
//
//    debugPrint("請求成功，回傳資料為：\(json)")
//}) { (error) in
//    debugPrint("請求失敗:\(error)")
//}.disposed(by: disposeBag)



//URLSession.shared.rx.data(request: request).subscribe(onNext:{
//    data in
//
//    let decoder = JSONDecoder()
//
//    do {
//
//        let json = try decoder.decode([WebAPIModelElement].self, from: data)
//        print("Json Result: \(json[0].title) \r\n\r\n")
//
//    }
//    catch let errorType
//    {
//        print("Json Parse 有錯誤: \(errorType.localizedDescription) \r\n\r\n")
//        print("error: \(errorType) \r\n\r\n")
//    }
//
//}) { (error) in
//    debugPrint("請求失敗:\(error)")
//}.disposed(by: disposeBag)

//    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {


private var jsonDecoder = JSONDecoder()
private var urlSession: URLSession

urlSession = URLSession(configuration: URLSessionConfiguration.default)

//MARK: function for URLSession takes
public func callAPI<T: Decodable>(request: URLRequest)
    -> Observable<T> {
        
        //MARK: creating our observable
        return Observable.create { observer in
            
            //MARK: create URLSession dataTask
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse{
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try jsonDecoder.decode(T.self, from: _data)
                            //MARK: observer onNext event
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


func send<T>(_ request: T) -> Observable<Data> {

    let request = URLRequest(url: URL(string: urlString)!)

    return Observable.create { obs in
        URLSession.shared.rx.response(request: request).debug("r").subscribe(
            onNext: { response in
                return obs.onNext(response.data)
        },
            onError: {error in
                obs.onError(error)
        })
    }
}


//send("qwe").subscribe(
//            onNext: { ev in
//            print(ev)
//        }, onError: { error in
//            print(error)
//        }).disposed(by: disposeBag)


func fetchCallAPI(request: URLRequest) -> Observable<[WebAPIModelElement]> {
    
    return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
    
            guard let data = data else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
    
            do {
                let albums = try JSONDecoder().decode([WebAPIModelElement].self, from: data)
                observer.onNext(albums)
            } catch {
                observer.onError(error)
            }
        }
        task.resume()
        return Disposables.create{
            task.cancel()
        }
    }
}



//fetchCallAPI(request: request).subscribe { (data) in
//    debugPrint("Json Data:\(data)")
//
//} onError: { (error) in
//    debugPrint("onError:\(error)")
//} onCompleted: {
//    debugPrint("onCompleted")
//}.disposed(by: disposeBag)


func fetchCallAPI1<T: Decodable>(request: URLRequest) -> Observable<T> {
    
    return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
    
            guard let data = data else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
    
            do {
                let albums = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(albums)
            } catch {
                observer.onError(error)
            }
        }
        task.resume()
        return Disposables.create{
            task.cancel()
        }
    }
}

//fetchCallAPI1(request: request).subscribe(
//onNext: {
//    (data :[WebAPIModelElement]) in
//    debugPrint("Json Data:\(data)")
//    PlaygroundPage.current.finishExecution()
//}, onError: {
//    error in
//    debugPrint("onError:\(error)")
//    PlaygroundPage.current.finishExecution()
//}, onCompleted: {
//    debugPrint("onCompleted")
//    PlaygroundPage.current.finishExecution()
//}).disposed(by: disposeBag)



enum HTTPMethod: String {
    case POST, GET
}

public protocol Request {
//    var path: String { get }
//    var method: HTTPMethod { get }
//    var param: [String: Any] { get }
    var request: URLRequest { get }
    associatedtype ResponseObject: Codable
}

protocol RequestSender {
    func send<T: Request>(_ r: T) -> Observable<T.ResponseObject?>
}

struct User: Codable {
    let id: String
    let name: String
    let gender: String
}

struct URLSessionRequestSender: RequestSender {
    func send<T>(_ r: T) -> Observable<T.ResponseObject?> where T : Request {
        
        
        return Observable.create { subscriber in
            let task =  URLSession.shared.dataTask(with: r.request) { data, res, error in
                if let data = data, let object = try? JSONDecoder().decode(T.ResponseObject.self, from: data) {
                    subscriber.onNext(object)
                } else {
                    subscriber.onError(error!)
                }
            }
            task.resume()
            return Disposables.create()

        }

    }
    
}

struct GetUserRequest: Request {
    var request: URLRequest
    
    typealias ResponseObject = [WebAPIModelElement]
    

}
//let request1 = GetUserRequest(request: request)
//
//_ = URLSessionRequestSender().send(request1).subscribe(onNext: { data in
//    if let data = data {
//        print("id is : \(data[0].id)")
//    } else {
//        print("got nothing")
//    }
//})



public protocol Request1 {
    var request: URLRequest { get }
    associatedtype ResponseObject:Codable
}

struct TESTRequest: Request1 {
    var request: URLRequest

    typealias ResponseObject = [WebAPIModelElement]

}


func fetchCallAPI2<T: Request1>(r:T) -> Observable<T.ResponseObject>{
    
    return Observable.create { observer -> Disposable in
        
        let task = URLSession.shared.dataTask(with: r.request) { data, _, _ in
    
            guard let data = data else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            do {
                let albums = try JSONDecoder().decode(T.ResponseObject.self, from: data)
                observer.onNext(albums)
            } catch {
                observer.onError(error)
            }
        }
        task.resume()
        return Disposables.create{
            task.cancel()
        }
    }
}

//let request1 = TESTRequest(request: request)
//
//fetchCallAPI2(r: request1)
//.subscribe(
//onNext: {
//    (data) in
//    debugPrint("Json Data:\(data)")
//    PlaygroundPage.current.finishExecution()
//}, onError: {
//    error in
//    debugPrint("onError:\(error)")
//    PlaygroundPage.current.finishExecution()
//}, onCompleted: {
//    debugPrint("onCompleted")
//    PlaygroundPage.current.finishExecution()
//}).disposed(by: disposeBag)


struct OneUserModel: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Codable {
    let lat, lng: String
}

// MARK: - Company
struct Company: Codable {
    let name, catchPhrase, bs: String
}


struct TESTRequest1: Request1 {
    var request: URLRequest

    typealias ResponseObject = OneUserModel

}

let request2 = TESTRequest1(request: request)

//fetchCallAPI2(r: request2)
//.subscribe(
//onNext: {
//    (data) in
//    debugPrint("Json Data1:\(data)")
//    PlaygroundPage.current.finishExecution()
//}, onError: {
//    error in
//    debugPrint("onError:\(error)")
//    PlaygroundPage.current.finishExecution()
//}, onCompleted: {
//    debugPrint("onCompleted")
//    PlaygroundPage.current.finishExecution()
//}).disposed(by: disposeBag)




let publisher = Observable<Decodable>.create{ observer -> Disposable in
    
    let task = URLSession.shared.dataTask(with: request) { data, _, _ in

        guard let data = data else {
            observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        
        do {
            let jsonData = try JSONDecoder().decode([WebAPIModelElement].self, from: data)
            observer.onNext(jsonData)
        } catch {
            observer.onError(error)
        }
    }
    task.resume()
    return Disposables.create{
        task.cancel()
    }
}


let subscription = publisher.subscribe(onNext: {
    (data) in
    debugPrint("Json Data1:\(data)")
    PlaygroundPage.current.finishExecution()
}, onError: {
    error in
    debugPrint("onError:\(error)")
    PlaygroundPage.current.finishExecution()
}, onCompleted: {
    debugPrint("onCompleted")
    PlaygroundPage.current.finishExecution()
}).disposed(by: disposeBag)

